//
//  NetworkRestaurantDetailTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

/// Pruebas unitarias para verificar el comportamiento de `NetworkRestaurantDetail`.
final class NetworkRestaurantDetailTest: XCTestCase {
    
    var network: NetworkRestaurantDetail!

    /// Configura una instancia de `NetworkRestaurantDetail` con una sesión de red simulada antes de cada prueba.
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        network = NetworkRestaurantDetail(session: session)
    }

    /// Libera los recursos y restablece los mocks después de cada prueba.
    override func tearDownWithError() throws {
        network = nil
        URLProtocolMock.statusCode = 200
        URLProtocolMock.stubResponseData = nil
        URLProtocolMock.error = nil
    }
    
    /// Verifica que la función `getRestaurantDetail` devuelva correctamente los datos del restaurante cuando el JSON es válido.
    func testNetworkRestaurantDetail_GivenASucessFullJson_ShouldSuccess() async throws {
        
        let data = try MockData.loadJSONData(name: "DetailRestaurantMock")
        URLProtocolMock.stubResponseData = data
        
        do {
            let restaurant = try await network.getRestaurantDetail(restaurantId: "516379B2-AECA-405A-87D3-B202F778EE6B")
            XCTAssertEqual(restaurant.name, "Restaurant Kevin")
            XCTAssertEqual(restaurant.address, "411, aspen canyon")
            XCTAssertEqual(restaurant.city, "San antonio")
            XCTAssertEqual(restaurant.country, "United States")
            XCTAssertEqual(restaurant.info, "Comida tipica")
            XCTAssertEqual(restaurant.photo, "/restaurant_photos/58D131BA-A84C-41C6-8C8F-3D66F30A861A.jpg")
            XCTAssertEqual(restaurant.zipCode, "78253")
            XCTAssertEqual(restaurant.meals.count, 3)
            XCTAssertEqual(restaurant.meals[0].name, "Locro de papa")
            XCTAssertEqual(restaurant.meals[0].photo, "/restaurant_photos/05109A06-E736-4D80-AE90-8095F28A1940.png")
            XCTAssertEqual(restaurant.meals[0].price, 2.5)
        } catch {
            XCTFail()
        }
    }

    /// Verifica que la función `getRestaurantDetail` lance un error cuando el JSON es inválido o el servidor devuelve un error.
    func testRestaurantDetail_GivenBadJson_ShouldFailure() async throws {
        let data = "{}".data(using: .utf8)
        URLProtocolMock.stubResponseData = data
        URLProtocolMock.statusCode = 500
        
        do {
            _ = try await network.getRestaurantDetail(restaurantId: "516379B2-AECA-405A-87D3-B202F778EE6B")
            XCTFail("We expect failure")
        } catch let error as PKError {
            XCTAssertEqual(error, .errorFromApi(statusCode: 500))
        } catch {
            XCTFail()
        }
    }
}
