//
//  DetaultRestaurantDetailRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 21/4/25.
//

import Foundation

final class DetaultRestaurantDetailRepository: RestaurantDetailRepositoryProtocol {
    private var network: NetworkRestaurantDetailProtocol
    
    init(network: NetworkRestaurantDetailProtocol = NetworkRestaurantDetail()) {
        self.network = network
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        return try await network.getRestaurantDetail(restaurantId: restaurantId)
    }
}

// MOCK SUCCESS
final class DetaultRestaurantDetailRepositorySuccessMock: RestaurantDetailRepositoryProtocol {
    private var network: NetworkRestaurantDetailProtocol
    
    init(network: NetworkRestaurantDetailProtocol = NetworkRestaurantDetailSuccessMock()) {
        self.network = network
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        return try await network.getRestaurantDetail(restaurantId: restaurantId)
    }
}

// MOCK FAILURE
final class DetaultRestaurantDetailRepositoryFailureMock: RestaurantDetailRepositoryProtocol {
    private var network: NetworkRestaurantDetailProtocol
    
    init(network: NetworkRestaurantDetailProtocol = NetworkRestaurantDetailFailureMock()) {
        self.network = network
    }
    
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel {
        throw PKError.badUrl
    }
}
