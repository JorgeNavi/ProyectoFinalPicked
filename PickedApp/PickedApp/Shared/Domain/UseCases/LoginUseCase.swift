//
//  LoginUseCase.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get set }
    
    func loginUser(user: String, password: String) async throws -> UserModel
    func logout() async -> Void
    func validateToken() async -> Bool
}

final class LoginUseCase: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol
    
    @pkPersistenceKeychain(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
    var tokenJWT
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository()) {
        self.repo = repo
    }
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        let userProfile = try await repo.loginUser(user: user, password: password)
        
        if userProfile.token != ""{
            tokenJWT = userProfile.token
        } else {
            tokenJWT = ""
        }
        
        return userProfile
    }
    
    func logout() async {
        KeyChainPK().deletePK(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        if tokenJWT != ""{
            return true
        } else {
            return false
        }
    }
}


///MOCK SUCCESS
final class LoginUseCaseSucessMock: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol
    var token: String = ""
    var status = Status.none
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepositoryMock()) {
        self.repo = repo
    }
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        let result = try await repo.loginUser(user: user, password: password)
        token = result.token
        return result
    }
    
    func logout() async {
        token = ""
        status = .login
    }
    
    func validateToken() async -> Bool {
        return !token.isEmpty
    }
}


///MOCK FAILURE
final class LoginUseCaseFailureMock: LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol = DefaultLoginRepositoryMock()
    
    func loginUser(user: String, password: String) async throws -> UserModel {
        throw PKError.authenticationFailed
    }
    
    func logout() async { }
    
    func validateToken() async -> Bool {
        return false
    }
}
