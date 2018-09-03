//
//  MockLoginService.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 03/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

class MockLoginService: LoginServiceProtocol {
    func login(withUsername username: String, andPassword password: String) -> SignalProducer<String, NSError> {
        if username == "name" && password == "pass" {
            return SignalProducer(value: "token")
        } else {
            let error = AppError(code: 1, message: "error")
            return SignalProducer(error: error)
        }
    }
}
