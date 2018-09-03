//
//  URLSession.swift
//  tesonetTestApp
//
//  Created by Martynas P on 28/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result

extension URLSession {

    static func authenticatedSession() -> URLSession {
        do {
            let config = try URLSessionConfiguration.authentication()
            return URLSession(configuration: config)
        } catch {
            fatalError("Requested authenticated session when access token is not stored")
        }
    }

    static func plainSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept-Language": "lt-LT", "Content-Type": "application/json"]
        return URLSession(configuration: config)
    }

    static func loginSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept-Language": "lt-LT", "Content-Type": "x-www-form-urlencoded"]
        return URLSession(configuration: config)
    }

    
}

extension Reactive where Base: URLSession {

    typealias DataObjectProducer = SignalProducer<Data, NSError>

    public func dataObject(with request: URLRequest) -> SignalProducer<Data, NSError> {
        return self.data(with: request)
            .mapError(createNSError)
            .flatMap(.merge, parseResponse)
    }

    // MARK: - Private

    private func parseResponse(_ data: Data, response: URLResponse) -> DataObjectProducer {
        guard let httpResp = response as? HTTPURLResponse else {
            return DataObjectProducer(error: AppError(code: 1, message: "Failed to proccess server response"))
        }
        do {
            return try producer(from: data, forCode: httpResp.statusCode)
        } catch {
            let error = parseError(from: data, forCode: httpResp.statusCode)
            return DataObjectProducer(error: error)
        }
    }

    private func producer(from data: Data, forCode code: Int) throws -> DataObjectProducer {
        switch(code) {
        case 200..<300:
            return DataObjectProducer(value: data)
        default:
            let error = parseError(from: data, forCode: code)
            return DataObjectProducer(error: error)
        }
    }

    private func parseError(from data: Data, forCode code: Int) -> NSError {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let description = json?["message"] as? String {
                return AppError(code: code, message: description)
            } else {
                return AppError(code: code, message: "Failed to process error description")
            }
        } catch {
            return AppError(code: code, message: "Failed to proccess server response")
        }
    }

    private func createNSError(from error: AnyError) -> NSError {
        return AppError(code: 1, message: error.localizedDescription)
    }
}
