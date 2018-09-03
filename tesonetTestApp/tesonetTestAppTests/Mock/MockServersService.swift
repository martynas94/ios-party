//
//  MockServersService.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

class MockServersService: ServersServiceProtocol {
    
    func fetchServers() -> SignalProducer<[Server], NSError> {
        let servers = [Server(with: "s1", distance: 200), Server(with: "s2", distance: 100)]
        return SignalProducer(value: servers)
    }
}
