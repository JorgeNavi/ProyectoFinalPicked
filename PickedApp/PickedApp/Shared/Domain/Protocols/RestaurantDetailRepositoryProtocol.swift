//
//  RestaurantDetailRepositoryProtocol.swift
//  PickedApp
//
//  Created by Kevin Heredia on 21/4/25.
//

import Foundation

protocol RestaurantDetailRepositoryProtocol {
    func getRestaurantDetail(restaurantId: String) async throws -> RestaurantDetailModel
}
