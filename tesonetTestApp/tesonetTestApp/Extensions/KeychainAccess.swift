//
//  KeychainAccess.swift
//  tesonetTestApp
//
//  Created by Martynas P on 29/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import KeychainAccess

extension Keychain {

    static var application: Keychain {
        return Keychain(service: Bundle.main.bundleIdentifier!)
    }

    var hasAccessToken: Bool { return accessToken != nil }

    var accessToken: String? {
        do {
            return try get(.accessTokenKey)
        } catch {
            fatalError("Keychain error: \(error)")
        }
    }
}

extension String {

    static var accessTokenKey: String { return "token" }
}
