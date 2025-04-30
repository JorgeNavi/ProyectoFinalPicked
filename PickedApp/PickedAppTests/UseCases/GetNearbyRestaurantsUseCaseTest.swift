//
//  GetNearbyRestaurantsUseCaseTest.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//

import XCTest
import CoreLocation
@testable import PickedApp

final class GetNearbyRestaurantsUseCaseTest: XCTestCase {
    
    var useCase: GetNearbyRestaurantsUseCase!
    var useCaseFailure: GetNearbyRestaurantsUseCase!
    
    override func setUpWithError() throws {
        useCase = GetNearbyRestaurantsUseCase(repo: DefaultGetNearbyRestaurantsRepositorySuccessMock())
        useCaseFailure = GetNearbyRestaurantsUseCase(repo: DefaultGetNearbyRestaurantsRepositoryFailureMock())
    }
    
    override func tearDownWithError() throws {
        useCase = nil
        useCaseFailure = nil
    }
    
    func testGetNearbyRestaurantsSuccess() async throws {
        let coordinate = CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
        let restaurants = try await useCase.getRestaurantNearby(coordinate: coordinate)
        XCTAssertEqual(restaurants.count, 3)
    }
    
    func testGetNearbyRestaurantsFailure() async throws {
        do {
            let _ = try await useCaseFailure.getRestaurantNearby(coordinate: CLLocationCoordinate2D())
            XCTFail("expected to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .badUrl)
        } catch {
            XCTFail()
        }
    }
    
}
