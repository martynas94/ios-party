//
//  ServersModelProtocol.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import enum Result.NoError

protocol ServersModelProtocol {
    var serversSignal: Signal<[Server], NoError> { get }
    var errorSignal: Signal<NSError, NoError> { get }

    func fetchServers()
    func saveServers(_ servers: [Server])
    func loadServers()
    func deleteAllServers()
}
