//
//  ServersDatabaseProtocol.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

protocol ServersDatabaseProtocol {
    func save(_ servers: [Server])
    func load() -> [Server]?
    func deleteAll()
}
