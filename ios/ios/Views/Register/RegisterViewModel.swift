//
//  RegisterViewModel.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Foundation

final class RegisterViewModel: ObservableObject {
    private let userService = UserService()
    
    @Published var name = ""
    @Published var login = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var error: String? = nil
    var onSuccess: (() -> Void)?

    func signUp() async {
        guard login.count <= 30 else {
            error = "Login cannot be longer than 30 characters."
            return
        }
        
        do {
            _ = try await userService.register(name: name, login: login, password: password)
            DispatchQueue.main.async {
                self.onSuccess?()
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Registration failed: \(error.localizedDescription)"
            }
        }
    }
}
