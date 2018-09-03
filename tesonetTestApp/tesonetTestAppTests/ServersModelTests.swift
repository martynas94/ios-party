//
//  ServersModelTests.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 03/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import XCTest

import ReactiveSwift

class ServersModelTests: XCTestCase {

    var model: ServersModel!
    var servers: [Server]!
    let database = MockServersDatabase()
    let service = MockServersService()

    override func setUp() {
        model = ServersModel(with: service, database: database)

        servers = [Server(with: "s1", distance: 200), Server(with: "s2", distance: 100)]
    }

    func testFetchServers() {
        let exp = expectation(description: "Is equal")

        model.serversSignal.observe(on: UIScheduler()).observeValues({
            XCTAssertEqual(self.servers.first,$0.first)
            exp.fulfill()
        })
        model.fetchServers()
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testLoadServers() {
        let exp = expectation(description: "Is loaded")
        XCTAssertEqual(database.isLoaded, false)

        model.fetchServers()
        model.serversSignal.observe(on: UIScheduler()).take(first: 1).observeValues({
            if self.servers.first == $0.first {
                self.model.loadServers()
                XCTAssertEqual(self.database.isLoaded, true)
                exp.fulfill()
            }
        })

        waitForExpectations(timeout: 3, handler: nil)
    }

    func testDeleteAllServers() {
        XCTAssertEqual(database.isDeleted, false)
        model.deleteAllServers()
        XCTAssertEqual(database.isDeleted, true)
    }
}
