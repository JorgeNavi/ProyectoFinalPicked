//
//  RestaurantDetailModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 21/4/25.
//

import Foundation

// MARK: - Welcome
struct RestaurantDetailModel: Codable {
    let id: String
    let photo: String
    let address: String
    let country: String
    let meals: [Meal]
    let name: String
    let city: String
    let zipCode: String
    let info: String
    let latitude, longitude: Double
    
    var photoRestaurant: URL? {
        guard let url = URL(string: "\(ConstantsApp.CONS_API_URL)\(photo)") else {
            return nil
        }
        return url
    }
}
