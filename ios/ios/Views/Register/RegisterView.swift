//
//  RegisterView.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    var onSuccess: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register to Nightwind")
                .font(.custom(Styles.FontFamily.ebGaramond, size: 24))
                .foregroundColor(Styles.Light.text)
            
            InputField(text: $viewModel.name, placeholder: "Name")
            InputField(text: $viewModel.login, placeholder: "Login")
            InputField(text: $viewModel.password, placeholder: "Password", isSecure: true)
            InputField(text: $viewModel.confirmPassword, placeholder: "Confirm Password", isSecure: true)
            
            HStack {
                Button(action: {
                    Task {
                        await viewModel.signUp()
                    }
                }) {
                    Text("Sign up")
                        .foregroundColor(Styles.Light.primaryText)
                        .padding()
                        .background(Styles.Light.primaryBase)
                        .cornerRadius(8)
                }
                .onAppear {
                    viewModel.onSuccess = onSuccess
                }
                
                Text("or")
                    .font(.custom(Styles.FontFamily.lato, size: 14))
                Button("Sign in") {
                    onSuccess()
                }
            }
        }
        .padding()
    }
}
