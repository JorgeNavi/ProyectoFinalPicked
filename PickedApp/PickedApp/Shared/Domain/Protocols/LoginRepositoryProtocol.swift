//
//  LoginRepositoryProtocol.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation

protocol LoginRepositoryProtocol {
    func loginUser(user: String, password: String) async throws -> UserModel
}
