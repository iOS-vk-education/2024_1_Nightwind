//
//  UIStyles.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 08.01.2025.
//  Copyright © 2025 Nightwind Development. All rights reserved.
//

import UIKit

struct UIStyles {
    struct Light {
        static let primaryBase = UIColor(hex: "#b4e6ed")
        static let primaryText = UIColor(hex: "#122e3a")
        static let secondaryBase = UIColor(hex: "#ddebab")
        static let secondaryText = UIColor(hex: "#1e280b")
        static let tetriaryBase = UIColor(hex: "#bdc2ff")
        static let tetriaryText = UIColor(hex: "#231a4c")
        static let errorBase = UIColor(hex: "#ffd2c8")
        static let errorText = UIColor(hex: "#471408")
        static let none = UIColor.black
        static let text = UIColor(hex: "#262626")
        static let script = UIColor(hex: "#454545")
        static let outline = UIColor(hex: "#737373")
        static let trace = UIColor(hex: "#b0b0b0")
        static let base = UIColor(hex: "#f6f6f6")
        static let full = UIColor.white
        static let green = UIColor(hex: "#6e8b25")
        static let red = UIColor(hex: "#e24420")
    }
    
    struct FontFamily {
        static let ebGaramond = UIFont(name: "EBGaramond-Regular", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
        static let lato = UIFont(name: "Lato-Regular", size: UIFont.systemFontSize) ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    struct Shadow {
        struct EL2 {
            static let color = UIColor.black.withAlphaComponent(0.2).cgColor
            static let x: CGFloat = 0
            static let y: CGFloat = 2
            static let radius: CGFloat = 4
        }
    }
}

// UIColor extension for Hex conversion
extension UIColor {
    convenience init(hex: String) {
        var rgbValue: UInt64 = 0
        let formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
