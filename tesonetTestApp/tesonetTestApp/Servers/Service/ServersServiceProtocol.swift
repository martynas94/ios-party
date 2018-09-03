//
//  ServersServiceProtocol.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

protocol ServersServiceProtocol {
    func fetchServers() -> SignalProducer<[Server], NSError>
}
