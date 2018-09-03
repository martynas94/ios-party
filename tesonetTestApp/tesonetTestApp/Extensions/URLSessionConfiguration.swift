//
//  URLSessionConfiguration.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import KeychainAccess

extension URLSessionConfiguration {

    static var login: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        return config
    }

    static func authentication() throws -> URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default

        let keychain = Keychain.application
        let accessToken = try keychain.getString(.accessTokenKey)
        sessionConfig.httpAdditionalHeaders = [ "Content-Type": "application/json",
                                                "Authorization": "Bearer \(accessToken!)"]

        return sessionConfig
    }
}
