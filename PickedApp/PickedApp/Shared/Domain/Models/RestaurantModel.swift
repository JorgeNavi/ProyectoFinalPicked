//
//  Restaurants.swift
//  PickedApp
//
//  Created by Kevin Heredia on 18/4/25.
//

import Foundation

struct RestaurantModel: Identifiable, Codable {
    let id: String
    let name: String
    let info: String
    let address: String
    let zipCode: String
    let city: String
    let country: String
    let photo: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    let user: Editor
    
    var photoRestaurant: URL? {
        guard let url = URL(string: "\(ConstantsApp.CONS_API_URL)\(photo)") else {
            return nil
        }
        return url
    }
}

struct Editor: Codable {
    let id: String?
}


