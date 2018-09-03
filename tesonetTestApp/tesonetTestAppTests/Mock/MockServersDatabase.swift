//
//  MockServersDatabase.swift
//  tesonetTestAppTests
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

class MockServersDatabase: ServersDatabaseProtocol {

    var isSaved = false
    var isLoaded = false
    var isDeleted = false

    func save(_ servers: [Server]) {
        isSaved = true
    }

    func load() -> [Server]? {
        isLoaded = isSaved
        return nil
    }

    func deleteAll() {
        isDeleted = true
    }

}
