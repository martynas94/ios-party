//
//  LoginServiceProtocol.swift
//  tesonetTestApp
//
//  Created by Martynas P on 29/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

protocol LoginServiceProtocol {
    func login(withUsername username: String, andPassword password: String) -> SignalProducer<String, NSError>
}
