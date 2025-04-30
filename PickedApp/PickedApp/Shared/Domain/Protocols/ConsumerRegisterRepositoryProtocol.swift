//
//  ConsumerRegisterRepositoryProtocol.swift
//  PickedApp
//
//  Created by Kevin Heredia on 15/4/25.
//

import Foundation

protocol ConsumerRegisterRepositoryProtocol {
    func consumerRegister(name: String, email: String, password: String, role: String) async throws -> ConsumerUserModel
}
