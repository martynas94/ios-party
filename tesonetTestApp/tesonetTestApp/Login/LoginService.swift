//
//  LoginService.swift
//  tesonetTestApp
//
//  Created by Martynas P on 29/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

class LoginService: RemoteService, LoginServiceProtocol {

    private let path = "http://playground.tesonet.lt/v1/tokens"

    init() {
        super.init()
        let config = URLSessionConfiguration.login
        self.session = URLSession(configuration: config)
    }

    func login(withUsername username: String, andPassword password: String) -> SignalProducer<String, NSError> {
        let params = ["username": username as AnyObject, "password": password as AnyObject]
        let request = URLRequest.requestToken(forUrlString: path, params: params)

        return perform(request).flatMap(.merge, parseLoginResponse)
    }

    private func parseLoginResponse(_ data: Data) -> SignalProducer<String, NSError> {
        let missingTokenError = AppError(code: 1, message: "Server error. Access token not found, try again")
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                return SignalProducer(error: missingTokenError)
            }
            guard let token = json[.accessTokenKey] as? String else {
                return SignalProducer(error: missingTokenError)
            }
            return SignalProducer(value: token)
        } catch let error {
            let err = AppError(code: 1, message: error.localizedDescription)
            return SignalProducer(error: err)
        }
    }
}
