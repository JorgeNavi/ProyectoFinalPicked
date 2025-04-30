//
//  JWTDecoder.swift
//  PickedApp
//
//  Created by Jorge Navidad Espliego on 22/4/25.
//


import Foundation

//MARK: - Método para decodificar el rol del usuario a partir del token JWT
struct JWTDecoder {
    
    static func decodeRole(from token: String) -> String? {
        
        //Separar el token JWT por puntos (header.payload.signature)
        let segments = token.split(separator: ".")
        
        //Verificar que el token tenga al menos dos segmentos
        guard segments.count > 1 else { return nil }

        //Obtener el payload (segundo segmento del token)
        let payloadSegment = segments[1]
        var base64String = String(payloadSegment)
        
        //Asegurar que el string base64 tenga el padding correcto
        base64String = base64String.padding(toLength: ((base64String.count + 3) / 4) * 4,
                                            withPad: "=",
                                            startingAt: 0)
        
        //Decodificar el payload de base64 a JSON
        guard let data = Data(base64Encoded: base64String),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let role = json["role"] as? String else {
            return nil  //Devolver nil si algo falla en la decodificación
        }

        //Devolver el rol del usuario
        return role
    }
}
