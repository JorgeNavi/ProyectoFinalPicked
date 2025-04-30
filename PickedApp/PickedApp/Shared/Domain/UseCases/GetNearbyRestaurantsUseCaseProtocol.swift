//
//  GetNearbyRestaurantsUseCaseProtocol.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//

import Foundation
import CoreLocation

protocol GetNearbyRestaurantsUseCaseProtocol {
    
    var repo: GetNearbyRestaurantsRepositoryProtocol { get set }
    
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel]
}

final class GetNearbyRestaurantsUseCase: GetNearbyRestaurantsUseCaseProtocol {
    var repo: GetNearbyRestaurantsRepositoryProtocol
    
    init(repo: GetNearbyRestaurantsRepositoryProtocol = DefaultGetNearbyRestaurantsRepository()) {
        self.repo = repo
    }
    
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        return try await repo.getRestaurantNearby(coordinate: coordinate)
    }
}

final class GetNearbyRestaurantsUseCaseSuccessMock: GetNearbyRestaurantsUseCaseProtocol {
    var repo: GetNearbyRestaurantsRepositoryProtocol
    
    init(repo: GetNearbyRestaurantsRepositoryProtocol = DefaultGetNearbyRestaurantsRepositorySuccessMock()) {
        self.repo = repo
    }
    
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        return try await repo.getRestaurantNearby(coordinate: coordinate)
    }
}

final class GetNearbyRestaurantsUseCaseFailureMock: GetNearbyRestaurantsUseCaseProtocol {
    var repo: GetNearbyRestaurantsRepositoryProtocol
    
    init(repo: GetNearbyRestaurantsRepositoryProtocol = DefaultGetNearbyRestaurantsRepositoryFailureMock()) {
        self.repo = repo
    }
    
    func getRestaurantNearby(coordinate: CLLocationCoordinate2D) async throws -> [RestaurantModel] {
        throw PKError.badUrl
    }
}
