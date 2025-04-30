//
//  DefaultGetNearbyRestaurantsRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//


//
//  DefaultGetNearbyRestaurantsRepository.swift
//  PickedApp
//
//  Created by Kevin Heredia on 25/4/25.
//

import Foundation
import CoreLocation

final class DefaultGetNearbyRestaurantsRepository: GetNearbyRestaurantsRepositoryProtocol {
    
    private var network: NetworkGetNearbyRestaurantsProtocol
    
    init(network: NetworkGetNearbyRestaurantsProtocol = NetworkGetNearbyRestaurants()) {
        self.network = network
    }
    
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        return try await network.getRestaurantNearby(coordinate: coordinate)
    }
}

final class DefaultGetNearbyRestaurantsRepositorySuccessMock: GetNearbyRestaurantsRepositoryProtocol {
    
    private var network: NetworkGetNearbyRestaurantsProtocol
    
    init(network: NetworkGetNearbyRestaurantsProtocol = NetworkGetNearbyRestaurantsSuccessMock()) {
        self.network = network
    }
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        return try await network.getRestaurantNearby(coordinate: coordinate)
    }
}

final class DefaultGetNearbyRestaurantsRepositoryFailureMock: GetNearbyRestaurantsRepositoryProtocol {
    
    private var network: NetworkGetNearbyRestaurantsProtocol
    
    init(network: NetworkGetNearbyRestaurantsProtocol = NetworkGetNearbyRestaurantsFailureMock()) {
        self.network = network
    }
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        throw PKError.badUrl
    }
}
