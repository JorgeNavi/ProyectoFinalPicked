//
//  UserSessionManager.swift
//  PickedApp
//
//  Created by Kevin Heredia on 23/4/25.
//

import Foundation

class UserSessionManager {
    
    // La clave para almacenar los datos del usuario sin el token
    private static let userKey = ConstantsApp.CONS_USER_KEY

    // Función para guardar el usuario sin el token
    static func saveUser(_ user: UserProfile) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    // Función para obtener el usuario sin el token
    static func getUser() -> UserProfile? {
        if let savedUserData = UserDefaults.standard.object(forKey: userKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserProfile.self, from: savedUserData) {
                return loadedUser
            }
        }
        return nil
    }

    // Función para eliminar los datos del usuario
    static func deleteUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}


