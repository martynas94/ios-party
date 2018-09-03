//
//  LoginViewModel.swift
//  tesonetTestApp
//
//  Created by Martynas P on 29/08/2018.
//  Copyright © 2018 Martynas Pasilis. All rights reserved.
//

import Foundation

import ReactiveSwift
import Result
import KeychainAccess

class LoginViewModel {

    private let loginService: LoginServiceProtocol

    let loginCompletionSignal: Signal<Void, NoError>
    private let loginCompletionObserver: Signal<Void, NoError>.Observer

    let errorSignal: Signal<NSError, NoError>
    private let errorObserver: Signal<NSError, NoError>.Observer

    let isLoginViewEnabled: Property<Bool>
    private let (isLoggingSignal, isLoggingObserver) = Signal<Bool, NoError>.pipe()

    let serverFetchCompletionSignal: Signal<[Server], NoError>
    private let serverFetchCompletionObserver: Signal<[Server], NoError>.Observer

    init(with service: LoginServiceProtocol) {
        self.loginService = service

        (loginCompletionSignal, loginCompletionObserver) = Signal<Void, NoError>.pipe()
        (errorSignal, errorObserver) = Signal<NSError, NoError>.pipe()
        (serverFetchCompletionSignal, serverFetchCompletionObserver) = Signal<[Server], NoError>.pipe()

        isLoginViewEnabled = Property.init(initial: true, then: isLoggingSignal.negate())
    }

    func login(withUsername username: String?, andPassword password: String?) {
        guard let (n, p) = check(username: username, withPassword: password) else { return }

        isLoggingObserver.send(value: true)
        loginService.login(withUsername: n, andPassword: p).startWithResult(analyseLoginResult)
    }

    func fetchServers(from serverService: ServersServiceProtocol) {
        serverService.fetchServers().startWithResult(analyseServersResult)
    }

    private func check(username name: String?, withPassword pass: String?) -> (username: String, password: String)? {
        if let n = name, let p = pass {
            if !n.isEmpty && !p.isEmpty {
                return (username: n, password: p)
            }
        }

        let error = AppError(code: 1, message: "Username or password text field is empty")
        sendError(error)
        return nil
    }

    private func analyseLoginResult(_ result: Result<String, NSError>) {
            result.analysis(
                ifSuccess: self.handleLoginResult,
                ifFailure: self.sendError
        )
    }


    private func handleLoginResult(_ token: String) {
        let keychain = Keychain.application
        do {
            try keychain.set(token, key: .accessTokenKey)
            loginCompletionObserver.sendCompleted()
        } catch {
            let error = AppError(code: 1, message: "Error occured while saving your log in data. Try again")
            sendError(error)
        }
    }

    private func analyseServersResult(_ result: Result<[Server], NSError>) {
        result.analysis(
            ifSuccess: ({ serverFetchCompletionObserver.send(value: $0) }),
            ifFailure: { _ in serverFetchCompletionObserver.send(value: []) }
        )
    }

    private func sendError(_ error: NSError) {
        isLoggingObserver.send(value: false)
        errorObserver.send(value: error)
    }

}
