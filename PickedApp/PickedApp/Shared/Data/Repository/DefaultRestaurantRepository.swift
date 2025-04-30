//
//  DefaultRestaurantRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 17/4/25.
//

import Foundation

final class DefaultRestaurantRepository: RestaurantRegisterRepositoryProtocol {
    private var network: NetworkRestaurantRegisterProtocol

    init(network: NetworkRestaurantRegisterProtocol = NetworkRestaurantRegister()) {
        self.network = network
    }

    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        try await network.restaurantRegister(from: formData)
    }
}

final class DefaultRestaurantRepositoryMock: RestaurantRegisterRepositoryProtocol {
    private var network: NetworkRestaurantRegisterProtocol

    init(network: NetworkRestaurantRegisterProtocol = NetworkRestaurantRegisterMock()) {
        self.network = network
    }

    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        try await network.restaurantRegister(from: formData)
    }
}

final class DefaultRestaurantRepositoryFailureMock: RestaurantRegisterRepositoryProtocol {
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        throw PKError.errorFromApi(statusCode: 400)
    }
}
