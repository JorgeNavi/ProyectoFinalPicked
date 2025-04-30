//
//  ConsumerRegisterViewModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 15/4/25.
//

import Foundation

/// ViewModel that handles user registration.
@Observable
final class ConsumerRegisterViewModel {
    
    // MARK: - Properties
    
    private var appState: AppStateVM
    var isloading: Bool = false // Shows if loading is in progress
    var isRegistered: Bool = false // Shows if user is registered
    var errorMessage: String? // Stores error messages
    var tokenJWT: String = ""

    @ObservationIgnored
    private let useCase: ConsumerRegisterUseCaseProtocol
    @ObservationIgnored
    var isLogged: Bool = false // Indicates if the user is logged in
    
    // MARK: - Initialization

    /// Creates the view model with a use case and app state.
    init(useCase: ConsumerRegisterUseCaseProtocol = ConsumerRegisterUseCase(), appState: AppStateVM) {
        self.useCase = useCase
        self.appState = appState
    }
    
    // MARK: - Methods

    /// Registers a consumer and updates the app state based on the result.
    @MainActor
    func consumerRegister(name: String, email: String, password: String, role: String) async -> String? {
        
        if let validationError = validateFields(name: name, email: email, password: password) {
            isloading = false
            return validationError
        }

        isloading = true
        errorMessage = nil
        appState.status = .loading
        
        do {
            let result = try await useCase.consumerRegisterUser(name: name, email: email, password: password, role: role)
            
            appState.userProfileData = UserProfile(name: result.name, email: result.email, role: result.role)
            UserSessionManager.saveUser(appState.userProfileData)
            
            if !result.token.isEmpty {
                appState.status = .loaded
                isloading = false
                return nil
            } else {
                appState.status = .error(error: "Incorrect username or password.")
                isloading = false
                return "Incorrect username or password."
            }
        } catch {
            appState.status = .error(error: "Something went wrong.")
            isloading = false
            return "Something went wrong."
        }
    }
    
    // MARK: - Validation

    /// Checks that all fields are filled and email/password are valid.
    func validateFields(name: String, email: String, password: String) -> String? {
        if name.isEmpty || email.isEmpty || password.isEmpty {
            return "All fields are required."
        }
        if !email.contains("@") || !email.contains(".") {
            return "Invalid email."
        }
        if password.count < 6 {
            return "Invalid password."
        }
        return nil
    }
}
