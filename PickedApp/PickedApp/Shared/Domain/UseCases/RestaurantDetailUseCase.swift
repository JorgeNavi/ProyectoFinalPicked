//
//  RestaurantDetailUseCase.swift
//  PickedApp
//
//  Created by Kevin Heredia on 21/4/25.
//

import Foundation

protocol RestaurantDetailUseCaseProtocol {
    var repo: RestaurantDetailRepositoryProtocol { get set }
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel
}

final class RestaurantDetailUseCase: RestaurantDetailUseCaseProtocol {
    var repo: RestaurantDetailRepositoryProtocol
    
    init(repo: RestaurantDetailRepositoryProtocol = DetaultRestaurantDetailRepository()) {
        self.repo = repo
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        return try await repo.getRestaurantDetail(restaurantId: restaurantId)
    }
}

// MOCK SUCCESS
final class RestaurantDetailUseCaseSucessMock: RestaurantDetailUseCaseProtocol {
    var repo: RestaurantDetailRepositoryProtocol
    
    init(repo: RestaurantDetailRepositoryProtocol = DetaultRestaurantDetailRepositorySuccessMock()) {
        self.repo = repo
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        return try await repo.getRestaurantDetail(restaurantId: restaurantId)
    }
}

// MOCK FAILURE
final class RestaurantDetailUseCaseFailureMock: RestaurantDetailUseCaseProtocol {
    var repo: RestaurantDetailRepositoryProtocol
    
    init(repo: RestaurantDetailRepositoryProtocol = DetaultRestaurantDetailRepositoryFailureMock()) {
        self.repo = repo
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        throw PKError.badUrl
    }
}
