//
//  ServersModel.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

class ServersModel: ServersModelProtocol {

    let serversSignal: Signal<[Server], NoError>
    private let serversObserver: Signal<[Server], NoError>.Observer

    let errorSignal: Signal<NSError, NoError>
    private let errorObserver: Signal<NSError, NoError>.Observer

    private let service: ServersServiceProtocol
    private let database: ServersDatabaseProtocol

    init(with service: ServersServiceProtocol, database: ServersDatabaseProtocol) {
        self.service = service
        self.database = database
        (serversSignal, serversObserver) = Signal<[Server], NoError>.pipe()
        (errorSignal, errorObserver) = Signal<NSError, NoError>.pipe()
    }

    func fetchServers() {
        service.fetchServers().startWithResult(analyseServersResult)
    }

    func loadServers() {
        if let servers = database.load() {
            serversObserver.send(value: servers)
        } else {
            fetchServers()
        }
    }

    func deleteAllServers() {
        database.deleteAll()
    }

    func saveServers(_ servers: [Server]) {
        database.save(servers)
    }

    private func analyseServersResult(_ result: Result<[Server], NSError>) {
        DispatchQueue.main.async {
            result.analysis(ifSuccess: self.handleServersResult,
                            ifFailure: self.sendError)
        }
    }


    private func handleServersResult(_ servers: [Server]) {
        saveServers(servers)
        serversObserver.send(value: servers)
    }

    private func sendError(_ error: NSError) {
        errorObserver.send(value: error)
    }
}
