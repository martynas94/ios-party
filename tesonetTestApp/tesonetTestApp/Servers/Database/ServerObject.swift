//
//  ServerObject.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import RealmSwift

class ServerObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var distance: Int = 0

    convenience init(server: Server) {
        self.init()
        self.name = server.name
        self.distance = server.distance
    }
}
