//
//  LoginViewController.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import UIKit

import ReactiveSwift
import ReactiveCocoa

fileprivate let EmbedLoadingViewControllerSegueId = "embedLoadingViewControllerSegue"
fileprivate let ShowMainViewControllerSegueId = "showMainViewControllerSegue"

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginView: UIView!
    @IBOutlet var loadingViewContainer: UIView!

    var viewModel: LoginViewModel!
    private var loadingVC: LoadingViewController?

    var previousVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        if previousVC != nil {
            previousVC?.dismiss(animated: true, completion: nil)
        }
        setupViewModel()
        bindViewModel()
        hideKeyboardWhenTappedAround()
    }

    @IBAction func login(_ sender: Any) {
        viewModel.login(withUsername: usernameTextField.text, andPassword: passwordTextField.text)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EmbedLoadingViewControllerSegueId {
            loadingVC = segue.destination as? LoadingViewController
        } else if segue.identifier == ShowMainViewControllerSegueId {
            let dest = segue.destination as! ServersViewController
            dest.previousVC = self
            if let servers = sender as? [Server] {
                let model = ServersModel(with: ServersService(), database: ServersDatabase())
                let viewModel = ServersViewModel(with: model)
                viewModel.servers.swap(servers)
                dest.viewModel = viewModel
            }
        }
    }
    
    private func setupViewModel() {
        viewModel = LoginViewModel(with: LoginService())
    }

    private func bindViewModel() {
        loginView.reactive.isUserInteractionEnabled <~ viewModel.isLoginViewEnabled

        viewModel.loginCompletionSignal
            .observe(on: UIScheduler())
            .observeCompleted {
                self.loginView.isHidden = true
                self.loadingViewContainer.isHidden = false
                self.loadingVC?.startRotating()
                self.viewModel.fetchServers(from: ServersService())
        }

        viewModel.serverFetchCompletionSignal
            .observe(on: UIScheduler())
            .observeValues({
                self.performSegue(withIdentifier: ShowMainViewControllerSegueId, sender: $0)
            })

        viewModel.errorSignal
            .observe(on: UIScheduler())
            .observeValues(self.presentError)
    }

}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing()
        return false
    }
}

