//
//  GetNearbyRestaurantViewModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI

/// ViewModel que gestiona la lógica para mostrar restaurantes cercanos en el mapa.
@Observable
final class GetNearbyRestaurantViewModel {
    
    var locationService = LocationService() // Servicio para obtener la ubicación actual.
    @ObservationIgnored
    private var useCase: GetNearbyRestaurantsUseCaseProtocol // Caso de uso para obtener restaurantes cercanos.
    
    var restaurantsNearby: [RestaurantModel] = [] // Lista de restaurantes obtenidos.
    var search: String = "" // Texto de búsqueda para filtrar restaurantes.
    var selectedRestaurant: RestaurantModel? // Restaurante seleccionado por el usuario.
    var cameraPosition: MapCameraPosition = .automatic // Posición de la cámara en el mapa.
    
    /// Filtra los restaurantes según el texto de búsqueda.
    var restaurantFilter: [RestaurantModel] {
        if search.isEmpty {
            restaurantsNearby
        } else {
            restaurantsNearby.filter { $0.name.localizedStandardContains(search) }
        }
    }
    
    /// Inicializa el ViewModel con su caso de uso correspondiente.
    init(useCase: GetNearbyRestaurantsUseCaseProtocol = GetNearbyRestaurantsUseCase()) {
        self.useCase = useCase
    }
    
    /// Carga la ubicación actual y los restaurantes cercanos.
    @MainActor
    func loadData() async throws {
        do {
            let coordinates = try await locationService.requestLocation()
            updateCamera(to: coordinates)
            try await fetchRestaurants(near: coordinates)
        } catch {
            print("Error loading data: \(error)")
            throw PKError.badUrl
        }
    }
    
    func loadDataMock() async throws {
        do {
            let coordinates = try await locationService.requestLocationMock()
            await updateCamera(to: coordinates)
            try await fetchRestaurants(near: coordinates)
        } catch {
            print("Error loading data: \(error)")
            throw PKError.badUrl
        }
    }
    
    /// Obtiene los restaurantes cercanos según las coordenadas dadas.
    @MainActor
    private func fetchRestaurants(near coordinate: CLLocationCoordinate2D) async throws {
        let result = try await useCase.getRestaurantNearby(coordinate: coordinate)
        restaurantsNearby = result
    }
    
    /// Actualiza la posición de la cámara en el mapa.
    @MainActor
    private func updateCamera(to coordinate: CLLocationCoordinate2D) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    /// Guarda el restaurante seleccionado para mostrar más detalles.
    @MainActor
    func selectRestaurant(_ restaurant: RestaurantModel) {
        selectedRestaurant = restaurant
    }
    
    @MainActor
    func centerOnUserLocation() async {
        do {
            let coordinate = try await locationService.requestLocation()
            updateCamera(to: coordinate)
        } catch {
            print("Error centering on user location: \(error)")
        }
    }

}
