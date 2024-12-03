//
//  AuthViewModel.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

final class AuthViewModel: ObservableObject {
    private let userService = UserService()
    
    @Published var login = ""
    @Published var password = ""
    @Published var error: String?
    @Published var validationErrors: [String: String] = [:]
    
    func signIn() async {
        do {
            let _ = try await userService.auth(login: login, password: password)
            self.validationErrors = [:]
        } catch let e as APIError {
            if !e.validationErrors.isEmpty {
                self.validationErrors = e.validationErrors
                self.error = nil
            }
            if e.statusCode == 401 || e.statusCode == 400 {
                self.validationErrors = [:]
                self.error = "Wrong login or password"
            }
        } catch {}
    }
}
