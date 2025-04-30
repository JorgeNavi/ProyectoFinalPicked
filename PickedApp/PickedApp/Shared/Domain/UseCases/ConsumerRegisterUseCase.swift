//
//  ConsumerRegisterUseCase.swift
//  PickedApp
//
//  Created by Kevin Heredia on 15/4/25.
//

import Foundation

protocol ConsumerRegisterUseCaseProtocol {
    var repo: ConsumerRegisterRepositoryProtocol { get set }
    func consumerRegisterUser(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel
}

final class ConsumerRegisterUseCase: ConsumerRegisterUseCaseProtocol {
    
    var repo: ConsumerRegisterRepositoryProtocol
    
    @pkPersistenceKeychain(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
    var tokenJWT
    
    init(repo: ConsumerRegisterRepositoryProtocol = DefaultConsumerRegisterRepository()) {
        self.repo = repo
    }
    
    func consumerRegisterUser(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        let consumerUser = try await repo.consumerRegister(name: name, email: email, password: password, role: role)
        
        if consumerUser.token != "" {
            tokenJWT = consumerUser.token
        } else {
            tokenJWT = ""
        }
        return consumerUser
    }
}


final class ConsumerRegisterUseCaseMock: ConsumerRegisterUseCaseProtocol {
    
    var repo: ConsumerRegisterRepositoryProtocol
    var token: String = ""
    
    init(repo: ConsumerRegisterRepositoryProtocol = DefaultConsumerRegisterRepositoryMock()) {
        self.repo = repo
    }
    
    func consumerRegisterUser(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        let result = try await repo.consumerRegister(name: name, email: email, password: password, role: role)
        token = result.token
        return result
    }
}

final class ConsumerRegisterUseCaseFailureMock: ConsumerRegisterUseCaseProtocol {
    
    var repo: ConsumerRegisterRepositoryProtocol
    
    init(repo: ConsumerRegisterRepositoryProtocol = DefaultConsumerRegisterRepositoryFailureMock()) {
        self.repo = repo
    }
    
    func consumerRegisterUser(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel {
        throw PKError.dataNoReveiced
    }
}
