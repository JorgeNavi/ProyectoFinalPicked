//
//  PKError.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation

enum PKError: Error, CustomStringConvertible {
    case requestWasNil
    case errorFromServer(reason: Error)
    case errorFromApi(statusCode: Int)
    case dataNoReveiced
    case errorParsingData
    case sessionTokenMissing
    case badUrl
    case authenticationFailed
    case locationDisabled
    case noLocationFound
    
    var description: String {
        switch self {
            
        case .requestWasNil:
            return "Error creating request"
        case .errorFromServer(reason: let reason):
            return "Received error from server \((reason as NSError).code)"
        case .errorFromApi(statusCode: let statusCode):
            return "Received error from api status code \(statusCode)"
        case .dataNoReveiced:
            return "Data no received from server"
        case .errorParsingData:
            return "There was un error parsing data"
        case .sessionTokenMissing:
            return "Seesion token is missing"
        case .badUrl:
            return "Bad url"
        case .authenticationFailed:
            return "Authentication failed"
        case .locationDisabled:
            return "Location disabled"
        case .noLocationFound:
            return "No location found"
        }
    }
}

extension PKError: Equatable {
    static func == (lhs: PKError, rhs: PKError) -> Bool {
           switch (lhs, rhs) {
           case (.requestWasNil, .requestWasNil),
                (.dataNoReveiced, .dataNoReveiced),
                (.errorParsingData, .errorParsingData),
                (.sessionTokenMissing, .sessionTokenMissing),
                (.badUrl, .badUrl),
                (.authenticationFailed, .authenticationFailed):
               return true

           case let (.errorFromApi(code1), .errorFromApi(code2)):
               return code1 == code2

           case let (.errorFromServer(reason1), .errorFromServer(reason2)):
               let ns1 = reason1 as NSError
               let ns2 = reason2 as NSError
               return ns1.domain == ns2.domain && ns1.code == ns2.code

           default:
               return false
           }
       }
    
    
}
