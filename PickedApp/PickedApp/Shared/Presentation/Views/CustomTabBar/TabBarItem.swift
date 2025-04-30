//
//  TabBarItem.swift
//  PickedApp
//
//  Created by Kevin Heredia on 22/4/25.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, map, profile
    
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .map: return "map.fill"
        case .profile: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .map: return "Map"
        case .profile: return "Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return Color.white
        case .map: return Color.white
        case .profile: return Color.white
        }
    }
}

