//
//  AuthViewModel.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    private let userService: UserService
    
    init(userService: UserService) {
        self.userService = userService
    }
    
    @Published var login = ""
    @Published var password = ""
    @Published var error: String?
    @Published var validationErrors: [String: String] = [:]
    
    func signIn() async -> Bool {
        do {
            let _ = try await userService.auth(login: login, password: password)
            validationErrors = [:]
            return true
        } catch let apiError as APIError {
            handleAPIError(apiError)
        } catch {
            self.error = "An unexpected error occurred."
        }
        
        return false
    }
    
    func registerVIew(showRegister: Binding<Bool>) -> RegisterView {
        return RegisterView(userService: self.userService, onSuccess: { showRegister.wrappedValue = false })
    }

    private func handleAPIError(_ error: APIError) {
        switch error {
        case .networkError(let networkError):
            self.error = "Network error: \(networkError.localizedDescription)"
        case .serverError(let statusCode, let validationErrors):
            if !validationErrors.isEmpty {
                self.validationErrors = validationErrors
                self.error = nil
            } else if statusCode == 401 || statusCode == 400 {
                self.validationErrors = [:]
                self.error = "Wrong login or password"
            }
        case .unknownError:
            self.error = "An unexpected error occurred."
        }
    }
}
