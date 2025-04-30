//
//  ConsumerUserModel.swift
//  PickedApp
//
//  Created by Kevin Heredia on 27/4/25.
//

import Foundation

struct ConsumerUserModel: Codable, Identifiable {
    let email: String
    let token: String
    let id: UUID
    let role: String
    let name: String
}
