//
//  ConsumerRegisterUseCaseTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

final class ConsumerRegisterUseCaseTest: XCTestCase {
    
    var useCase: ConsumerRegisterUseCase!
    var useCaseFailure: ConsumerRegisterUseCase!

    override func setUpWithError() throws {
        useCase = ConsumerRegisterUseCase(repo: DefaultConsumerRegisterRepositoryMock())
        useCaseFailure = ConsumerRegisterUseCase(repo: DefaultConsumerRegisterRepositoryFailureMock())
    }

    override func tearDownWithError() throws {
        useCase = nil
        useCaseFailure = nil
    }
    
    func testconsumerRegisterSuccess() async throws {
        let registerConsumer = try await useCase.consumerRegisterUser(name: "John", email: "john@example.com", password: "password123", role: "consumer")
        
        XCTAssertNotNil(registerConsumer)
        XCTAssertFalse(useCase.tokenJWT.isEmpty)
    }
    
    func testConsumerRegisterFailure() async throws {
        do {
            let _ = try await useCaseFailure.consumerRegisterUser(name: "", email: "", password: "", role: "")
            XCTFail("expected to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .errorFromApi(statusCode: 400))
        } catch {
            XCTFail()
        }
    }

}
