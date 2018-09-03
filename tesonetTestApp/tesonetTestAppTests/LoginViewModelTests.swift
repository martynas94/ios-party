//
//  LoginViewModelTests.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 03/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import XCTest

import ReactiveSwift
import Result

class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!

    override func setUp() {
        let service = MockLoginService()
        viewModel = LoginViewModel(with: service)
    }

    func testNilLogin() {
        let exp = expectation(description: "")

        viewModel.errorSignal.observe(on: UIScheduler()).observeValues({
            XCTAssertEqual($0.localizedDescription, "Username or password text field is empty")
            exp.fulfill()
        })
        viewModel.login(withUsername: nil, andPassword: nil)

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testEmptyLogin() {
        let exp = expectation(description: "")

        viewModel.errorSignal.observe(on: UIScheduler()).observeValues({
            XCTAssertEqual($0.localizedDescription, "Username or password text field is empty")
            exp.fulfill()
        })
        viewModel.login(withUsername: "", andPassword: "test")

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testServerFetchCompletion() {
        let exp = expectation(description: "")

        viewModel.serverFetchCompletionSignal.signal.observe(on: UIScheduler()).observeValues({
            XCTAssertEqual($0.first, Server(with: "s1", distance: 200))
            exp.fulfill()
        })
        viewModel.fetchServers(from: MockServersService())

        waitForExpectations(timeout: 3, handler: nil)
    }
}
