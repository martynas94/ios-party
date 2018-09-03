//
//  URLRequest.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

extension URLRequest {
    
    static func request(forUrlString urlString: String,
                        method: RequestMethod = .get,
                        params: [String: AnyObject]? = nil) -> URLRequest {
        guard var urlComponents = URLComponents(string: urlString) else {
            fatalError("Could not create url components from urlString: \(urlString)")
        }

        if let p = params , method.isGet {
            let queryItems = p.map({ URLQueryItem(name: $0, value: $1 as? String) })
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            fatalError("Could not create url from components: \(urlComponents)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        guard let p = params, !method.isGet else { return request }

        if let data = try? JSONSerialization.data(withJSONObject: p, options: [.prettyPrinted]) {
            request.httpBody = data
        }

        return request
    }

    static func requestToken(forUrlString urlString: String,
                             params: [String: AnyObject]) -> URLRequest {
        guard let url = URL(string: urlString) else {
            fatalError("Could not create url components from urlString: \(urlString)")

        }

        var request = URLRequest(url: url)
        request.httpMethod = RequestMethod.post.rawValue

        let charset = CharacterSet.urlQueryAllowed
        let sortedKeys = params.keys.sorted()
        var query = ""

        for key in sortedKeys {
            if let escapedValue = String(describing: params[key]!).addingPercentEncoding(withAllowedCharacters: charset) {
                query += "\(key)=\(escapedValue)&"
            }
        }

        request.httpBody = query.data(using: .utf8)
        return request
    }
}
