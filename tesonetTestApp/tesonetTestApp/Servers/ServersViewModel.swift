//
//  ServersViewModel.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

class ServersViewModel {

    private let model: ServersModelProtocol

    let servers = MutableProperty<[Server]>([])

    var errorSignal: Signal<NSError, NoError> {
        return model.errorSignal
    }

    private var sortOption = ServerSortType.name

    init(with model: ServersModelProtocol) {
        self.model = model
        setupModel()
        bindModel()
    }

    func updateServers() {
        model.fetchServers()
    }

    func sort(by option: ServerSortType) {
        self.sortOption = option
        let sorted = sort(servers.value, by: option)
        servers.swap(sorted)
    }

    private func setupModel() {
        if !servers.value.isEmpty {
            model.deleteAllServers()
            model.saveServers(servers.value)
            sort(by: sortOption)
        } else {
            updateServers()
        }
    }

    private func bindModel() {
        model.serversSignal.observeValues({
            let sorted = self.sort($0, by: self.sortOption)
            self.servers.swap(sorted)
        })
    }

    private func sort(_ servers: [Server], by option: ServerSortType) -> [Server] {
        var sortedServers = servers
        if option == .name {
            sortedServers.sort(by: { $1.name > $0.name })
        } else {
            sortedServers.sort(by: { $1.distance > $0.distance })
        }
        return sortedServers
    }


}
