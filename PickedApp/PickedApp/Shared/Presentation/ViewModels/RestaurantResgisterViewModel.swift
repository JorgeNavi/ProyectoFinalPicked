//
//  RestaurantResgisterViewModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 17/4/25.
//

import Foundation
import CoreLocation
import PhotosUI
import SwiftUI

@Observable
final class RestaurantResgisterViewModel {
    
    private var appState: AppStateVM
    var address: String = ""
    var latitude: Double?
    var longitude: Double?
    var isLoading: Bool = false
    var errorMessage: String?
    var tokenJWT: String = ""
    var isRegistered: Bool = false
    
    @ObservationIgnored
    private let useCase: RestaurantRegisterUseCaseProtocol
    
    init(useCase: RestaurantRegisterUseCaseProtocol = RestaurantRegisterUseCase(), appState: AppStateVM) {
        self.useCase = useCase
        self.appState = appState
    }
    
    /// Envia el formulario utilizando el caso de uso.
    func restaurantRegister(
        email: String,
        password: String,
        role: String,
        restaurantName: String,
        info: String,
        address: String,
        country: String,
        city: String,
        zipCode: String,
        name: String,
        photo: Data?
    ) async throws -> String? {
        
        // Validar que todos los campos estén completos
        if let validationError = validateFields(
            email: email,
            password: password,
            restaurantName: restaurantName,
            info: info,
            address: address,
            country: country,
            city: city,
            zipCode: zipCode,
            name: name
        ) {
            self.errorMessage = validationError
            return validationError
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // Obtener coordenadas
            let coordinates = try await GeocodingHelper.getCoordinates(
                street: address,
                zipCode: zipCode,
                city: city,
                country: country
            )
            print("✅ Coordenadas obtenidas: Latitud: \(coordinates.latitude), Longitud: \(coordinates.longitude)")
            self.latitude = coordinates.latitude
            self.longitude = coordinates.longitude
            
            
            let formData = RestaurantRegisterRequest(
                email: email,
                password: password,
                role: role,
                restaurantName: restaurantName,
                info: info,
                address: address,
                country: country,
                city: city,
                zipCode: zipCode,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                name: name,
                photo: photo
            )
            
            let result = try await useCase.restaurantRegister(formData: formData)
            
            if result {
                appState.status = .restaurantMeals
                isLoading = false
                return nil
            } else {
                appState.status = .error(error: "Incorrect form")
                isLoading = false
                return "Incorrect"
            }
            
        } catch {
            self.appState.status = .error(error: "Something went wrong.")
            self.errorMessage = "Error al registrar el restaurante: \(error.localizedDescription)"
            return "Something went wrong."
        }
    }
    /// Función que valida que todos los campos estén llenos
    private func validateFields(
        email: String,
        password: String,
        restaurantName: String,
        info: String,
        address: String,
        country: String,
        city: String,
        zipCode: String,
        name: String
    ) -> String? {
        if email.isEmpty || password.isEmpty || restaurantName.isEmpty || info.isEmpty || address.isEmpty || country.isEmpty || city.isEmpty || zipCode.isEmpty || name.isEmpty {
            return "All fields are required."
        }
        return nil
    }
}
