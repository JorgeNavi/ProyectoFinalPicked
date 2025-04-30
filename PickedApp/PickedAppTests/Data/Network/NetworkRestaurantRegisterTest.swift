//
//  NetworkRestaurantRegisterTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 23/4/25.
//

import XCTest
@testable import PickedApp

/// Pruebas unitarias para validar el registro de restaurantes usando mocks de red.
final class NetworkRestaurantRegisterTest: XCTestCase {
    
    /// Mock que simula una respuesta exitosa del registro de restaurante.
    var networkRestaurantRegisterMock: NetworkRestaurantRegisterProtocol!
    
    /// Mock que simula una respuesta fallida del registro de restaurante.
    var networkRestaurantRegisterFailureMock: NetworkRestaurantRegisterProtocol!

    /// Configura los mocks antes de cada prueba.
    override func setUpWithError() throws {
        networkRestaurantRegisterMock = NetworkRestaurantRegisterMock()
        networkRestaurantRegisterFailureMock = NetworkRestaurantRegisterFailureMock()
    }
    
    /// Verifica que el registro exitoso del restaurante no lance errores y los valores sean correctos.
    func testRestaurantRegisterSuccess() async {
        // Given
        let resturant = RestaurantRegisterRequest(
            email: "test@example.com",
            password: "test",
            role: "restaurant",
            restaurantName: "test",
            info: "test",
            address: "test",
            country: "test",
            city: "test",
            zipCode: "test",
            latitude: 0.0,
            longitude: 0.0,
            name: "test",
            photo: Data()
        )
       
        do {
            _ = try await networkRestaurantRegisterMock.restaurantRegister(from: resturant)
        } catch {
            XCTFail("Expected success, but got error: \(error.localizedDescription)")
        }
        
        // Validaciones de los campos enviados
        XCTAssertEqual(resturant.name, "test")
        XCTAssertEqual(resturant.email, "test@example.com")
        XCTAssertEqual(resturant.role, "restaurant")
        XCTAssertEqual(resturant.info, "test")
        XCTAssertEqual(resturant.address, "test")
        XCTAssertEqual(resturant.country, "test")
        XCTAssertEqual(resturant.city, "test")
        XCTAssertEqual(resturant.zipCode, "test")
        XCTAssertEqual(resturant.latitude, 0.0)
        XCTAssertEqual(resturant.longitude, 0.0)
    }
    
    /// Verifica que se lance un error apropiado cuando el registro del restaurante falla.
    func testRestaurantRegisterFailure() async {
        let restaurant = RestaurantRegisterRequest(
            email: "test@example.com",
            password: "test",
            role: "restaurant",
            restaurantName: "test",
            info: "test",
            address: "test",
            country: "test",
            city: "test",
            zipCode: "test",
            latitude: 0.0,
            longitude: 0.0,
            name: "test",
            photo: Data()
        )
        
        do {
            _ = try await networkRestaurantRegisterFailureMock.restaurantRegister(from: restaurant)
        } catch let error as PKError {
            // Verifica que sea el error esperado de la API
            switch error {
            case .errorFromApi(let statusCode):
                XCTAssertEqual(statusCode, 400, "El código de error debería ser 400.")
            default:
                XCTFail("Se lanzó un PKError, pero no fue el esperado.")
            }
        } catch {
            XCTFail("Se lanzó un error inesperado: \(error)")
        }
    }
}
