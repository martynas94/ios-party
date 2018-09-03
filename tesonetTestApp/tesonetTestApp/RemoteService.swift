//
//  RemoteService.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift

class RemoteService: NSObject {

    var session: URLSession

    init(withSession session: URLSession = URLSession.plainSession()) {
        self.session = session
    }

    func perform(_ request: URLRequest) -> SignalProducer<Data, NSError> {
        return self.session.reactive.dataObject(with: request)
    }
}
