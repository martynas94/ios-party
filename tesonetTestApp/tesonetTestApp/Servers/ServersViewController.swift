//
//  ServersViewController.swift
//  tesonetTestApp
//
//  Created by Martynas P on 01/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import UIKit

import ReactiveSwift
import KeychainAccess

fileprivate let ShowLoginViewControllerSegueId = "showLoginViewControllerSegue"

class ServersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sortView: UIView!

    var refreshControl = UIRefreshControl()

    var previousVC: UIViewController?

    var viewModel: ServersViewModel?

    private var servers: [Server] {
        return viewModel?.servers.value ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if previousVC != nil {
            previousVC?.dismiss(animated: false, completion: nil)
        }
        setupTableView()
        setupViewModel()
        bindViewModel()
    }

    @IBAction func changeSortOption(_ sender: Any) {
        sortView.alpha = 0

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let distanceSortAction = UIAlertAction(title: "By Distance",
                                               style: .default,
                                               handler: { _ in
                                                self.viewModel?.sort(by: .distance)
                                                self.animateSortViewAppearance()
        })
        let nameSortAction = UIAlertAction(title: "Alphanumerical",
                                           style: .default,
                                           handler: { _ in
                                            self.viewModel?.sort(by: .name)
                                            self.animateSortViewAppearance()
        })
        let dismissAction = UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: { _ in self.animateSortViewAppearance() })

        actionSheet.addAction(distanceSortAction)
        actionSheet.addAction(nameSortAction)
        actionSheet.addAction(dismissAction)

        present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func logout(_ sender: Any) {
        performSegue(withIdentifier: ShowLoginViewControllerSegueId, sender: nil)
    }

    @objc func refresh(sender:AnyObject) {
        refreshControl.beginRefreshing()
        viewModel?.updateServers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowLoginViewControllerSegueId {
            let keychain = Keychain.application
            try? keychain.remove(.accessTokenKey)
            let dest = segue.destination as! LoginViewController
            dest.previousVC = self
        }
    }

    private func setupTableView() {
        let insets = UIEdgeInsets(top: 10, left: 0, bottom: 100, right: 0)
        self.tableView.contentInset = insets

        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }

    private func setupViewModel() {
        guard viewModel == nil else { return }
        let model = ServersModel(with: ServersService(), database: ServersDatabase())
        viewModel = ServersViewModel(with: model)
    }

    private func bindViewModel() {
        viewModel?.servers.signal
            .observe(on: UIScheduler())
            .observeValues({ _ in
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })

        viewModel?.errorSignal
            .observe(on: UIScheduler())
            .observeValues({
                self.refreshControl.endRefreshing()
                self.presentError($0)
            })
    }

    private func animateSortViewAppearance() {
        UIView.animate(withDuration: 0.2, animations: { self.sortView.alpha = 1 })
    }
}

extension ServersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServerTableViewCell.identifier) as! ServerTableViewCell
        cell.name.text = servers[indexPath.row].name
        cell.distance.text = servers[indexPath.row].distanceString
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
