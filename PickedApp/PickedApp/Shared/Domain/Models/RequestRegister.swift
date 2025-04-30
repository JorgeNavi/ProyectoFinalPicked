//
//  ConsumerRegisterRequest.swift
//  PickedApp
//
//  Created by Kevin Heredia on 15/4/25.
//

import Foundation

struct UserLoginRequest: Codable {
    let email: String
    let password: String
}

struct ConsumerRegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
    let role: String
}

struct RestaurantRegisterRequest: Codable {
    let email: String
    let password: String
    let role: String
    let restaurantName: String
    let info: String
    let address: String
    let country: String
    let city: String
    let zipCode: String
    let latitude: Double
    let longitude: Double
    let name: String
    let photo: Data?
}

struct MealCreateRequest: Codable {
    let name: String
    let info: String
    let units: Int
    let price: Float
    let type: String
    let photo: Data?
}

struct GetRestaurantNearbyRequest: Codable {
    let latitude: Double
    let longitude: Double
}
