//
//  NetworkConsumerRegisterTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 16/4/25.
//

import XCTest
@testable import PickedApp

// Test class that verifies the behavior of consumer registration
// in the network, using mocks to simulate successful or failed responses.
final class NetworkConsumerRegisterTest: XCTestCase {
    
    // Mocks used to simulate success and failure responses from the API.
    var networkConsumerRegisterMock: NetworkConsumerRegisterProtocol!
    var networkConsumerRegisterFailureMock: NetworkConsumerRegisterProtocol!
    
    // Method executed before each test. Sets up the required mocks.
    override func setUpWithError() throws {
        // Initialize mocks to simulate success and failure responses.
        networkConsumerRegisterMock = NetworkConsumerRegisterMock() // Simulates success
        networkConsumerRegisterFailureMock = NetworkConsumerRegisterFailureMock() // Simulates failure
    }
    
    // Test that verifies the successful registration of a consumer.
    func testConsumerRegisterSuccess() async {
        // Input data for the registration.
        let name = "Kevin Heredia"
        let email = "kevin@example.com"
        let password = "password"
        let role = "consumer"
        
        do {
            // Attempt to register a consumer using the success mock.
           _ = try await networkConsumerRegisterMock.consumerRegister(name: name, email: email, password: password, role: role)
        } catch {
            // If an error occurs, the test fails.
            XCTFail("Expected success, but got error: \(error.localizedDescription)")
        }
    }
    
    // Test that verifies the behavior when registration fails.
    func testConsumerRegisterFailure() async {
        // Input data for the registration.
        let name = "John Doe"
        let email = "john@example.com"
        let password = "password123"
        let role = "consumer"
        
        do {
            // Execute registration using the failure mock.
            _ = try await networkConsumerRegisterFailureMock.consumerRegister(name: name, email: email, password: password, role: role)
            // If no error occurs, the test fails.
            XCTFail("Expected error, but registration succeeded.")
        } catch {
            // In case of an error, we expect this to be the correct behavior.
            XCTAssertNotNil(error, "Expected error but got nil.")
        }
    }
}
