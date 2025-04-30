//
//  RestaurantDetailUseCaseTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

final class RestaurantDetailUseCaseTest: XCTestCase {
    
    var useCase: RestaurantDetailUseCase!
    var useCaseFailure: RestaurantDetailUseCase!

    override func setUpWithError() throws {
        useCase = RestaurantDetailUseCase(repo: DetaultRestaurantDetailRepositorySuccessMock())
        useCaseFailure = RestaurantDetailUseCase(repo: DetaultRestaurantDetailRepositoryFailureMock())
    }

    override func tearDownWithError() throws {
        useCase = nil
        useCaseFailure = nil
    }

    func testGetRestaurantDetailSuccess() async throws {
        
        let restaurant = try await useCase.getRestaurantDetail(restaurantId: "516379B2-AECA-405A-87D3-B202F778EE6B")
        
        XCTAssertEqual(restaurant.name, "Restaurant Test")
        XCTAssertEqual(restaurant.country, "Estados Unidos")
        XCTAssertEqual(restaurant.city, "San Francisco")
        XCTAssertEqual(restaurant.address, "1529 Fillmore St")
        XCTAssertEqual(restaurant.zipCode, "78253")
    }
    
    func testGetRestaurantDetailFailure() async throws {
        do {
            let _ = try await useCaseFailure.getRestaurantDetail(restaurantId: "")
            XCTFail("Expected to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .badUrl)
        } catch {
            XCTFail()
        }
    }
}
