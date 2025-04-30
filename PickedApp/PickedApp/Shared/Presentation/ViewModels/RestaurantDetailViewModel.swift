//
//  RestaurantDetailViewModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 21/4/25.
//

import Foundation

@Observable
final class RestaurantDetailViewModel {

    var restaurantData = RestaurantDetailModel(id: "", photo: "", address: "", country: "", meals: [Meal(id: UUID(), name: "", info: "", units: 0, price: 0.0, photo: "")], name: "", city: "", zipCode: "", info: "", latitude: 0.0, longitude: 0.0)
    
    @ObservationIgnored
    private var useCase: RestaurantDetailUseCaseProtocol
    
    init(useCase: RestaurantDetailUseCaseProtocol = RestaurantDetailUseCase()) {
        self.useCase = useCase
    }
    
    @MainActor
    func getRestaurantDetail(restaurantId: String) async throws {
        let data = try await useCase.getRestaurantDetail(restaurantId: restaurantId)
        self.restaurantData = data
    }
}
