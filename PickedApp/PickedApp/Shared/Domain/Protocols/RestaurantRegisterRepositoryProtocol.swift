//
//  RestaurantRegisterRepositoryProtocol.swift
//  PickedApp
//
//  Created by Kevin Heredia on 17/4/25.
//

import Foundation

protocol RestaurantRegisterRepositoryProtocol {
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String
}
