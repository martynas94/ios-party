//
//  ServersService.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

class ServersService: RemoteService, ServersServiceProtocol {

    private let path = "http://playground.tesonet.lt/v1/servers"

    init() {
        super.init()
        do {
            let config = try URLSessionConfiguration.authentication()
            self.session = URLSession(configuration: config)
        } catch {
            fatalError("Requested authenticated session when access token is not stored")
        }
    }

    func fetchServers() -> SignalProducer<[Server], NSError> {
        let request = URLRequest.request(forUrlString: path)

        return perform(request).flatMap(.merge, parseServersResponse)
    }

    private func parseServersResponse(_ data: Data) -> SignalProducer<[Server], NSError> {
        do {
            let decoder = JSONDecoder()
            let servers = try decoder.decode([Server].self, from: data)
            return SignalProducer(value: servers)
        } catch let error {
            let appError = AppError(code: 1, message: error.localizedDescription)
            return SignalProducer(error: appError)
        }
    }
}
