//
//  NetworkRestaurantRegister.swift
//  PickedApp
//
//  Created by Kevin Heredia on 17/4/25.
//

import Foundation

/// Protocolo para registrar restaurantes en la red, devuelve un token JWT.
protocol NetworkRestaurantRegisterProtocol {
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String
}

/// Clase principal que implementa el registro de restaurantes en el servidor.
final class NetworkRestaurantRegister: NetworkRestaurantRegisterProtocol {
    
    /// Realiza una solicitud HTTP POST para registrar un restaurante usando datos en formato multipart.
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        var tokenJWT = ""
        
        // Construye la URL a partir de una constante base y el endpoint de registro.
        guard let url = URL(string: "\(ConstantsApp.CONS_API_URL)\(EndPoints.restaurantRegister.rawValue)") else {
            throw PKError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post
        
        //Establece el encabezado 'Content-Type' con un boundary único para el multipart/form-data.
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("\(HttpMethods.multipartFormData)\(boundary)", forHTTPHeaderField: HttpMethods.contentTypeID)
        
        //Crea el cuerpo de la solicitud con los datos del formulario codificados como multipart.
        let fields: [String: String] = [
            "email": formData.email,
            "password": formData.password,
            "role": formData.role,
            "restaurantName": formData.restaurantName,
            "info": formData.info,
            "address": formData.address,
            "country": formData.country,
            "city": formData.city,
            "zipCode": formData.zipCode,
            "latitude": String(formData.latitude),
            "longitude": String(formData.longitude),
            "name": formData.name
        ]

        let body = createMultipartBody(from: fields, imageData: formData.photo, imageFieldName: "photo", boundary: boundary)

        request.httpBody = body
        
        // Envía la solicitud y espera la respuesta de forma asíncrona.
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Verifica que la respuesta sea válida y del tipo HTTPURLResponse.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PKError.errorFromApi(statusCode: -1)
        }
        
        // Valida que el código de respuesta HTTP sea exitoso.
        guard httpResponse.statusCode == HttpResponseCodes.SUCESS else {
            throw PKError.errorFromApi(statusCode: httpResponse.statusCode)
        }
        
        do {

            // Decodifica el usuario de la respuesta JSON y obtiene el token.
            let result  = try JSONDecoder().decode(UserModel.self, from: data)
            tokenJWT = result.token
        } catch {
            // Captura e imprime cualquier error ocurrido durante el proceso.
            print("Error registering Restaurant \(error.localizedDescription)")
        }
        return tokenJWT
    }
}

/// Mock de prueba que simula un registro exitoso de restaurante devolviendo un token ficticio.
final class NetworkRestaurantRegisterMock: NetworkRestaurantRegisterProtocol {
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        return "mockToken"
    }
}

/// Mock de prueba que simula un fallo al registrar un restaurante lanzando un error HTTP.
final class NetworkRestaurantRegisterFailureMock: NetworkRestaurantRegisterProtocol {
    func restaurantRegister(from formData: RestaurantRegisterRequest) async throws -> String {
        throw PKError.errorFromApi(statusCode: 400)
    }
}
