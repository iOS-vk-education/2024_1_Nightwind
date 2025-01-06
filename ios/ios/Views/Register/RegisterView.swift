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
    @StateObject private var viewModel: RegisterViewModel
    var onSuccess: () -> Void
    
    init(userService: UserService, onSuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: RegisterViewModel(userService: userService))
        self.onSuccess = onSuccess
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Register to Nightwind")
                .font(.custom(Styles.FontFamily.ebGaramond, size: 24))
                .foregroundColor(Styles.Light.text)
            
            InputField(text: $viewModel.name, placeholder: "Name", error: $viewModel.validationErrors["name"])
            InputField(text: $viewModel.login, placeholder: "Login", error: $viewModel.validationErrors["login"])
            InputField(text: $viewModel.password, placeholder: "Password", isSecure: true, error: $viewModel.validationErrors["password"])
            InputField(text: $viewModel.confirmPassword, placeholder: "Confirm Password", isSecure: true, error: $viewModel.validationErrors["confirmPassword"])
            
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
