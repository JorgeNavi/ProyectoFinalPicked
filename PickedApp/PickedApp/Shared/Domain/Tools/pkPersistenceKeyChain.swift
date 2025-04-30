//
//  pkPersistenceKeyChain.swift
//  PickedApp
//
//  Created by Kevin Heredia on 14/4/25.
//

import Foundation

@propertyWrapper
class pkPersistenceKeychain {
    private var key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: String {
        get {
            return KeyChainPK().loadPK(key: self.key)
        }
        
        set {
            KeyChainPK().savePK(key: self.key, value: newValue)
        }
    }
}
