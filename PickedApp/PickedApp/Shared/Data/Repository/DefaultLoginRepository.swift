//
//  DefaultLoginRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation

final class DefaultLoginRepository: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol = NetworkLogin()) {
        self.network = network
    }
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        return try await network.loginUser(user: user, password: password)
    }
}

final class DefaultLoginRepositoryMock: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol = NetworkLoginMock()) {
        self.network = network
    }
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        return try await network.loginUser(user: user, password: password)
    }
}

final class DefaultLoginRepositoryFailureMock: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol = NetworkLoginErrorMock()) {
        self.network = network
    }
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        throw PKError.authenticationFailed
    }
}
