//
//  AuthView.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var showRegister = false
        
    var body: some View {
        ZStack {
            Styles.Light.base.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                        .font(.custom(Styles.FontFamily.lato, size: 20))
                        .foregroundColor(Styles.Light.text)
                    Text("Nightwind")
                        .font(.custom(Styles.FontFamily.ebGaramond, size: 42))
                        .foregroundColor(Styles.Light.text)
                }
                
                InputField(text: $viewModel.login, placeholder: "Login", error: viewModel.validationErrors["login"])
                InputField(text: $viewModel.password, placeholder: "Password", isSecure: true, error: viewModel.validationErrors["password"])
                
                if let error = viewModel.error {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(Styles.Light.errorText)
                }
                    
                HStack {
                    Button(action: {
                        Task {
                            await viewModel.signIn()
                        }
                    }) {
                        Text("Sign in")
                            .foregroundColor(Styles.Light.primaryText)
                            .padding()
                            .background(Styles.Light.primaryBase)
                            .cornerRadius(8)
                    }
                    
                    Text("or")
                        .font(.custom(Styles.FontFamily.lato, size: 14))
                    Button("Sign Up") {
                        showRegister = true
                    }
                    .sheet(isPresented: $showRegister) {
                        RegisterView(onSuccess: { showRegister = false })
                    }
                }
            }
            .padding()
        }
        .background(Styles.Light.base)
    }
}
