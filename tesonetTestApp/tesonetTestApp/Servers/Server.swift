//
//  Server.swift
//  tesonetTestApp
//
//  Created by Martynas P on 02/09/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

struct Server: Codable {
    let name: String
    let distance: Int

    enum CodingKeys: String, CodingKey {
        case name
        case distance
    }

    init(with name: String, distance: Int) {
        self.name = name
        self.distance = distance
    }
}

extension Server {

    var distanceString: String {
        return "\(distance) km"
    }
}

extension Server: Equatable { }

func ==(lhs: Server, rhs: Server) -> Bool {
    return lhs.name == rhs.name &&
        lhs.distance == rhs.distance
}

