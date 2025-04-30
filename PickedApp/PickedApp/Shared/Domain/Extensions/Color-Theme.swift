//
//  Color-Theme.swift
//  PickedApp
//
//  Created by Kevin Heredia on 8/4/25.
//

import Foundation
import SwiftUI

extension Color {
    static let primaryColor = Color(hex: "#F28A44")
    static let secondaryColor = Color(hex: "#B45227")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

extension ShapeStyle where Self == Color {
    static var primaryColor: Color {
        Color(red: 242 / 255, green: 138 / 255, blue: 68 / 255)  // #F28A44
    }
    
    static var secondaryColor: Color {
        Color(red: 180 / 255, green: 82 / 255, blue: 39 / 255)   // #B45227
    }
}

