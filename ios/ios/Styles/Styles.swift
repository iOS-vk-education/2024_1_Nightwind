//
//  Colors.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import SwiftUI

struct Styles {
    struct Light {
        static let primaryBase = Color(hex: "#b4e6ed")
        static let primaryText = Color(hex: "#122e3a")
        static let secondaryBase = Color(hex: "#ddebab")
        static let secondaryText = Color(hex: "#1e280b")
        static let tetriaryBase = Color(hex: "#bdc2ff")
        static let tetriaryText = Color(hex: "#231a4c")
        static let errorBase = Color(hex: "#ffd2c8")
        static let errorText = Color(hex: "#471408")
        static let none = Color.black
        static let text = Color(hex: "#262626")
        static let script = Color(hex: "#454545")
        static let outline = Color(hex: "#737373")
        static let trace = Color(hex: "#b0b0b0")
        static let base = Color(hex: "#f6f6f6")
        static let full = Color.white
    }
    
    struct FontFamily {
        static let ebGaramond = "EBGaramond-Regular"
        static let lato = "Lato-Regular"
    }
    
    struct Shadow {
        struct EL2 {
            static let color = Color.black.opacity(0.2)
            static let x: CGFloat = 0
            static let y: CGFloat = 2
            static let radius: CGFloat = 4
        }
    }
}

extension Color {
    init(hex: String) {
        var rgbValue: UInt64 = 0
        
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let scanner = Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
