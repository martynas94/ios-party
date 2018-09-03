//
//  ServersDatabase.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import RealmSwift

class ServersDatabase: ServersDatabaseProtocol {

    private let realm: Realm?

    init() {
        realm = try? Realm()
    }

    func save(_ servers: [Server]) {
        let objects = servers.map({ ServerObject(server: $0) })
        try? realm?.write {
            realm?.add(objects)
        }
    }

    func load() -> [Server]? {
        guard let objects = realm?.objects(ServerObject.self) else { return nil }
        return objects.map({ Server(with: $0.name, distance: $0.distance) })
    }

    func deleteAll() {
        guard let objects = realm?.objects(ServerObject.self) else { return }
        objects.forEach({ object in
            try? realm?.write {
                realm?.delete(object)
            }
        })
    }

    private func delete(_ server: Server) {
        let object = ServerObject(server: server)
        try? realm?.write {
            realm?.delete(object)
        }
    }

}

