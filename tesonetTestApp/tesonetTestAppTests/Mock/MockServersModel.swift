//
//  MockServersModel.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

class MockServersModel: ServersModelProtocol {
    var (serversSignal, serversObserver) = Signal<[Server], NoError>.pipe()
    var (errorSignal, _) = Signal<NSError, NoError>.pipe()

    var isSaved = false
    var isLoaded = false
    var isDeleted = false

    func fetchServers() {
        let servers = [Server(with: "s1", distance: 200),
                       Server(with: "a1", distance: 300),
                       Server(with: "s2", distance: 100)]
        serversObserver.send(value: servers)
    }

    func saveServers(_ servers: [Server]) {
        isSaved = true
    }

    func loadServers() {
        isLoaded = true
    }

    func deleteAllServers() {
        isDeleted = true
    }
}
