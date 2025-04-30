//
//  ConsumerRegisterVMTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 16/4/25.
//

import XCTest
@testable import PickedApp

/// Unit test class for testing the `ConsumerRegisterViewModel`.
final class ConsumerRegisterVMTest: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: ConsumerRegisterViewModel!
    var mockUseCase: ConsumerRegisterUseCaseProtocol!
    
    /// Sets up the test environment before each test case.
    /// Initializes the view model and mock use case with a fresh `AppState`.
    override func setUpWithError() throws {
        // Initialize the mock use case for the consumer registration use case
        mockUseCase = ConsumerRegisterUseCaseMock()
        
        // Initialize the AppState and ViewModel
        let appState = AppStateVM()
        viewModel = ConsumerRegisterViewModel(useCase: mockUseCase, appState: appState)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - Test Cases
    
    /// Tests the validation of registration fields (name, email, and password).
    func testValidateFields() {
        let validEmail = "test@example.com"
        let invalidEmail = "test.com"
        let validPassword = "password123"
        let shortPassword = "123"
        
        // Assert that no validation error occurs for valid inputs
        XCTAssertNil(viewModel.validateFields(name: "John", email: validEmail, password: validPassword))
        
        // Assert that an error message appears when fields are empty
        XCTAssertEqual(viewModel.validateFields(name: "", email: validEmail, password: validPassword), "All fields are required.")
        
        // Assert that an error message appears for an invalid email format
        XCTAssertEqual(viewModel.validateFields(name: "John", email: invalidEmail, password: validPassword), "Invalid email.")
        
        // Assert that an error message appears for short passwords
        XCTAssertEqual(viewModel.validateFields(name: "John", email: validEmail, password: shortPassword), "Invalid password.")
    }
    
    /// Tests a successful consumer registration process.
    /// Verifies that no error is returned when the registration is successful.
    func testConsumerRegisterSuccess() async {
        // Simulate a successful registration
        let result = await viewModel.consumerRegister(name: "John", email: "john@example.com", password: "password123", role: "consumer")
        
        // Assert that no error message is returned
        XCTAssertNil(result)
    }
    
    /// Tests the consumer registration process when an error occurs.
    /// Verifies that the appropriate error message is returned when the registration fails.
    func testConsumerRegisterFailure() async {
        // Change the mock to simulate a failure
        mockUseCase = ConsumerRegisterUseCaseFailureMock()
        viewModel = ConsumerRegisterViewModel(useCase: mockUseCase, appState: AppStateVM())
        
        // Simulate a failed registration
        let result = await viewModel.consumerRegister(name: "John", email: "john@example.com", password: "password123", role: "consumer")
        
        // Assert that the error message matches the expected failure message
        XCTAssertEqual(result, "Something went wrong.")
    }
}
