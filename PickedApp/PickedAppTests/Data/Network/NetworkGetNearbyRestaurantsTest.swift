//
//  NetworkGetNearbyRestaurantsTest.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//

import XCTest
import CoreLocation
@testable import PickedApp

final class NetworkGetNearbyRestaurantsTest: XCTestCase {
    
    var network: NetworkGetNearbyRestaurants!

    /// Configura una instancia de `NetworkGetNearbyRestaurants` con una sesión simulada antes de cada prueba.
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        network = NetworkGetNearbyRestaurants(session: session)
    }
    /// Libera los recursos y restablece los mocks después de cada prueba.
    override func tearDownWithError() throws {
        network = nil
        URLProtocolMock.statusCode = 200
        URLProtocolMock.stubResponseData = nil
        URLProtocolMock.error = nil
    }
    
    func testNetworkGetNearbyRestaurants_GivenASuccessJson_ShouldSuccess() async throws {
        
        let coordinates = CLLocationCoordinate2D(latitude: 37.785834, longitude: -122.406417)
        let data = try MockData.loadJSONData(name: "GetNearbyRestaurantsMock")
        URLProtocolMock.stubResponseData = data
        
        do {
            let restaurants = try await network.getRestaurantNearby(coordinate: coordinates)
            XCTAssertEqual(restaurants.count, 6)
            XCTAssertEqual(restaurants[0].name, "House of Prime Rib")
        } catch {
            XCTFail()
        }
    }
    
    func testNetworkGetNearbyRestaurants_GivenABadJson_ShouldFailure() async throws {
        let data = "{}".data(using: .utf8)
        URLProtocolMock.stubResponseData = data
        URLProtocolMock.statusCode = 500
        
        do {
            _ = try await network.getRestaurantNearby(coordinate: CLLocationCoordinate2D())
            XCTFail("expeted to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .errorFromApi(statusCode: 500))
        } catch {
            XCTFail()
        }
    }

}
