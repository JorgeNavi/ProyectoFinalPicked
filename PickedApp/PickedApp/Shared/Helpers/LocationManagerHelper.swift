//
//  LocationManagerHelper.swift
//  PickedApp
//
//  Created by Kevin Heredia on 18/4/25.
//

import Foundation
import CoreLocation

// Clase que maneja la obtención de la ubicación del usuario
final class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Objeto de CoreLocation que se encarga de acceder a la ubicación
    private let locationManager = CLLocationManager()
    
    // Continuación para poder usar async/await y esperar la ubicación
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    // Variable publicada que contiene la ubicación actual del usuario (para usar en SwiftUI)
    @Published var userLocation: CLLocationCoordinate2D?

    // Inicializador de la clase
    override init() {
        super.init()
        locationManager.delegate = self // Asignamos el delegate para recibir eventos de ubicación
    }

    // Función que solicita la ubicación del usuario de forma asíncrona
    func requestLocation() async throws -> CLLocationCoordinate2D {
        // Verifica que los servicios de ubicación estén activados
        guard CLLocationManager.locationServicesEnabled() else {
            throw PKError.locationDisabled
        }

        // Pide permiso para usar la ubicación mientras se usa la app
        locationManager.requestWhenInUseAuthorization()

        // Espera a que se reciba una ubicación antes de continuar
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            locationManager.requestLocation() // Solicita una ubicación al sistema
        }
    }

    // Método delegado que se llama cuando se obtiene una nueva ubicación
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            userLocation = coordinate // Actualiza la ubicación publicada
            locationContinuation?.resume(returning: coordinate) // Continúa el async con la coordenada
        } else {
            locationContinuation?.resume(throwing: PKError.noLocationFound) // Lanza error si no hay ubicación
        }
        locationContinuation = nil // Limpia la continuación
    }

    // Método delegado que se llama si ocurre un error al obtener la ubicación
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error) // Continúa el async lanzando el error recibido
        locationContinuation = nil // Limpia la continuación
    }
    
    func requestLocationMock() async throws -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038)
    }
}
