//
//  LoginUseCaseSuccessMock.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import Foundation
@testable import PickedApp

final class LoginUseCaseSuccessMock: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol = DefaultLoginRepositoryMock()
    var token: String = JWTMock.tokenWithRestaurantRole
    var status = Status.none
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        return UserModel(id: UUID(), name: "Kevin", email: "kevin@picked.com", role: "restaurant", token: token)
    }
    
    func logout() async {
        token = ""
        status = .login
    }
    
    func validateToken() async -> Bool {
        return !token.isEmpty
    }
}

struct JWTMock {
    static let tokenWithRestaurantRole = "mock.jwt.token.restaurant"
}

struct JWTDecoder {
    static func decodeRole(from token: String) -> String? {
        return "restaurant"
    }
}
