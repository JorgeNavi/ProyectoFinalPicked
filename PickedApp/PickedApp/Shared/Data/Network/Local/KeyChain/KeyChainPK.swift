//
//  KeyChainPK.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation
import KeychainSwift

public struct KeyChainPK {
    
    public init() { }
    
    @discardableResult
    public func savePK(key: String, value: String) -> Bool {
        if let data = value.data(using: .utf8) {
            let keychain = KeychainSwift()
            return keychain.set(data, forKey: key)
        } else {
            return false
        }
    }
    
    public func loadPK(key: String) -> String {
        let keychain = KeychainSwift()
        if let data = keychain.get(key) {
            return data
        } else {
            return ""
        }
    }
    
    @discardableResult
    public func deletePK(key: String) -> Bool {
        return KeychainSwift().delete(key)
    }
}
