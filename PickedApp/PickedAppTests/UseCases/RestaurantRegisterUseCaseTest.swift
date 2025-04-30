//
//  RestaurantRegisterUseCaseTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

final class RestaurantRegisterUseCaseTest: XCTestCase {
    
    var useCase: RestaurantRegisterUseCase!
    var useCaseFailure: RestaurantRegisterUseCase!

    override func setUpWithError() throws {
        useCase = RestaurantRegisterUseCase(repo: DefaultRestaurantRepositoryMock())
        useCaseFailure = RestaurantRegisterUseCase(repo: DefaultRestaurantRepositoryFailureMock())
    }

    override func tearDownWithError() throws {
        useCase = nil
        useCaseFailure = nil
    }
    func testRestaurantRegisterSuccess() async throws{
        let registerRestaurant = try await useCase.restaurantRegister(
            formData: RestaurantRegisterRequest(
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
        )
        
        XCTAssertTrue(registerRestaurant)
        XCTAssertFalse(useCase.tokenJWT.isEmpty)
    }
    func testRestaurantRegisterFailure() async throws {
        do {
            let _ = try await useCaseFailure.restaurantRegister(formData: RestaurantRegisterRequest(
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
            )
            XCTFail("expected to fail")
        } catch  let error as PKError {
            XCTAssertEqual(error, .errorFromApi(statusCode: 400))
        } catch {
            XCTFail()
        }
    }

}
