//
//  ServersViewModelTests.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 03/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import XCTest

import ReactiveSwift

class ServersViewModelTests: XCTestCase {

    var viewModel: ServersViewModel!
    let model = MockServersModel()
    var servers: [Server]!

    override func setUp() {
        viewModel = ServersViewModel(with: model)

        servers = [Server(with: "s1", distance: 200),
                   Server(with: "a1", distance: 300) ,
                   Server(with: "s2", distance: 100)]
    }

    func testViewModelInitialization() {
        viewModel.updateServers()

        let exp = expectation(description: "Test after 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewModel.servers.value.first, servers[1])
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testSortByName() {
        viewModel.updateServers()

        let exp = expectation(description: "Test after 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            viewModel.sort(by: .name)
            XCTAssertEqual(viewModel.servers.value.first, servers[1])
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testSortByDistance() {
        viewModel.updateServers()

        let exp = expectation(description: "Test after 3 seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: 3.0)
        if result == XCTWaiter.Result.timedOut {
            viewModel.sort(by: .distance)
            XCTAssertEqual(viewModel.servers.value.first, servers.last)
        } else {
            XCTFail("Delay interrupted")
        }
    }


}
