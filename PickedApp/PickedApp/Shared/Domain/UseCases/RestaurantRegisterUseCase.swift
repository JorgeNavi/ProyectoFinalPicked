//
//  RestaurantRegisterUseCase.swift
//  PickedApp
//
//  Created by Kevin Heredia on 17/4/25.
//

import Foundation

protocol RestaurantRegisterUseCaseProtocol {
    var repo: RestaurantRegisterRepositoryProtocol { get set }
    func restaurantRegister(formData: RestaurantRegisterRequest) async throws -> Bool
}


final class RestaurantRegisterUseCase: RestaurantRegisterUseCaseProtocol {
    var repo: RestaurantRegisterRepositoryProtocol
    
    @pkPersistenceKeychain(key: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
    var tokenJWT

    init(repo: RestaurantRegisterRepositoryProtocol = DefaultRestaurantRepository()) {
        self.repo = repo
    }

    func restaurantRegister(formData: RestaurantRegisterRequest) async throws -> Bool {
        let token = try await repo.restaurantRegister(from: formData)
        
        if token != "" {
            tokenJWT = token
            return true
        } else {
            tokenJWT = ""
            return false
        }
    }
}


final class RestaurantRegisterUseCaseMock: RestaurantRegisterUseCaseProtocol {
    var repo: RestaurantRegisterRepositoryProtocol

    var token: String = ""
    
    init(repo: RestaurantRegisterRepositoryProtocol = DefaultRestaurantRepositoryMock()) {
        self.repo = repo
    }

    func restaurantRegister(formData: RestaurantRegisterRequest) async throws -> Bool {
        let result = try await repo.restaurantRegister(from: formData)
        token = result
        return !token.isEmpty
    }
}


final class RestaurantRegisterUseCaseFailureMock: RestaurantRegisterUseCaseProtocol {
    var repo: RestaurantRegisterRepositoryProtocol

    init(repo: RestaurantRegisterRepositoryProtocol = DefaultRestaurantRepositoryFailureMock()) {
        self.repo = repo
    }

    func restaurantRegister(formData: RestaurantRegisterRequest) async throws -> Bool {
        return false
    }
}

