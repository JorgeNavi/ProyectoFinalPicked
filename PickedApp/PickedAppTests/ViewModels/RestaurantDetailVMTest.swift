//
//  RestaurantDetailVMTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

final class RestaurantDetailVMTest: XCTestCase {
    
    var viewModel: RestaurantDetailViewModel!
    var viewModelFailure: RestaurantDetailViewModel!
    
    override func setUpWithError() throws {
        viewModel = RestaurantDetailViewModel(useCase: RestaurantDetailUseCaseSucessMock())
        viewModelFailure = RestaurantDetailViewModel(useCase: RestaurantDetailUseCaseFailureMock())
    }

    override func tearDownWithError() throws {
        viewModel = nil
        viewModelFailure = nil
    }
    
    func testGetRestaurantDetailSuccessMock() async throws {
        
        let _ = try await viewModel.getRestaurantDetail(restaurantId: "516379B2-AECA-405A-87D3-B202F778EE6B")
        
        XCTAssertEqual(viewModel.restaurantData.name, "Restaurant Test")
        XCTAssertEqual(viewModel.restaurantData.country, "Estados Unidos")
        XCTAssertEqual(viewModel.restaurantData.city, "San Francisco")
        XCTAssertEqual(viewModel.restaurantData.address, "1529 Fillmore St")
        XCTAssertEqual(viewModel.restaurantData.zipCode, "78253")
    }
    
    func testGetRestaurantDetailFailureMock() async throws {
        do {
            let _ = try await viewModelFailure.getRestaurantDetail(restaurantId: "")
            XCTFail("expected to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .badUrl)
        } catch {
            XCTFail()
        }
    }

}
