//
//  InputField.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import SwiftUI

struct InputField: View {
    @FocusState private var isFocused: Bool
    
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var error: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Styles.Light.full)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Styles.Light.primaryBase : Styles.Light.full)
                    )
                    .shadow(
                        color: Styles.Shadow.EL2.color,
                        radius: Styles.Shadow.EL2.radius,
                        x: Styles.Shadow.EL2.x,
                        y: Styles.Shadow.EL2.y
                    )
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Styles.Light.full)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Styles.Light.primaryBase : Styles.Light.full)
                    )
                    .shadow(
                        color: Styles.Shadow.EL2.color,
                        radius: Styles.Shadow.EL2.radius,
                        x: Styles.Shadow.EL2.x,
                        y: Styles.Shadow.EL2.y
                    )
                    .focused($isFocused)
            }

            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(Styles.Light.errorText)
            }
        }
    }
}
