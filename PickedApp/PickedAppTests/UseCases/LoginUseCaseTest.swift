//
//  LoginUseCaseTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 24/4/25.
//

import XCTest
@testable import PickedApp

final class LoginUseCaseTest: XCTestCase {
    
    var useCase: LoginUseCase!
    var useCaseFailure: LoginUseCase!

    override func setUpWithError() throws {
        useCase = LoginUseCase(repo: DefaultLoginRepositoryMock())
        useCaseFailure = LoginUseCase(repo: DefaultLoginRepositoryFailureMock())
    }

    override func tearDownWithError() throws {
        useCase = nil
        useCaseFailure = nil
    }
    
    func testLoginSuccess() async throws {
        let user = try await useCase.loginUser(user: "test", password: "testpass")
        
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.role, "admin")
        XCTAssertEqual(user.token, "mocked_jwt_token")
        let isValid = await useCase.validateToken()
        XCTAssertTrue(isValid)
    }
    
    func testLoginFailure() async throws {
        do {
            let _ = try await useCaseFailure.loginUser(user: "", password: "")
            XCTFail("expected to fail")
        } catch let error as PKError {
            XCTAssertEqual(error, .authenticationFailed)
        } catch {
            XCTFail()
        }
    }
    
    func testLogOut() async throws {
        _ = try await useCase.loginUser(user: "test", password: "testpass")
        
        await useCase.logout()
        
        let isValid = await useCase.validateToken()
        XCTAssertFalse(isValid)
    }

}
