//
//  AppStateVMTest.swift
//  PickedAppTests
//
//  Created by Kevin Heredia on 15/4/25.
//

import XCTest
@testable import PickedApp

/// Tests for the `AppStateVM` view model, validating login flow, logout behavior, and status management.
final class AppStateVMTest: XCTestCase {
    
    // MARK: - Login Tests
    
    /// Tests that login with valid credentials sets status to `.loaded`.
    func testLoginUser_WithValidCredentialsAndRestaurantRole_UpdatesStatusToRestaurantMeals() async {
        // Arrange
        let loginUseCaseMock = LoginUseCaseSucessMock()
        let viewModel = AppStateVM(loginUseCase: loginUseCaseMock)

        // Forzamos el token con un rol "restaurant"
        loginUseCaseMock.token = JWTMock.tokenWithRestaurantRole
        KeyChainPK().savePK(key: loginUseCaseMock.token, value: ConstantsApp.CONS_TOKEN_ID_KEYCHAIN)
        // Act
        let errorMessage = await viewModel.loginUser(user: "kevin@picked.com", pass: "123456")

        // Assert
        XCTAssertNil(errorMessage)
        XCTAssertEqual(viewModel.userProfileData.name, "Test User")
    }

    /// Tests that login with incorrect credentials sets the status to `.error`.
    func testLoginUserFailure() async {
        // Given
        let sut = AppStateVM(loginUseCase: LoginUseCaseFailureMock())
        
        // When
        let errorMessage = await sut.loginUser(user: "test@example.com", pass: "example")
        
        // Then
        XCTAssertEqual(errorMessage, "An error occurred during login.")
    }
    
    /// Tests that login with invalid credentials does not proceed and shows validation error.
    func testLoginWithInvalidCretendials_shouldNotStartLogin() async {
        // Given
        let vm = AppStateVM(loginUseCase: LoginUseCaseSucessMock())
        
        // When
        let validationError = await vm.loginUser(user: "invalidemail", pass: "123")
        
        // Then
        XCTAssertEqual(validationError, "Invalid email or password.")
        XCTAssertEqual(vm.status, .none)
    }
    
    // MARK: - Token Validation
    
    /// Tests that when there is no valid token, the status transitions to `.none` or `.login`.
    func testValidateToken_whenInvalid_shouldSetStatusLoginAfterSplash() async {
        // Given
        let vm = AppStateVM(loginUseCase: LoginUseCaseSucessMock())
        
        // When
        await vm.validateControlLogin()
        
        // Then
        XCTAssertTrue([.none, .login].contains(vm.status))
    }
}
