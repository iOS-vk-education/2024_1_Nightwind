//
//  RegisterViewModel.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    private let userService = AppState.userService
    
    @Published var name = ""
    @Published var login = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var error: String? = nil
    @Published var validationErrors: [String: String] = [:]
    var onSuccess: (() -> Void)?

    func signUp() async {
        guard login.count <= 30 else {
            error = "Login cannot be longer than 30 characters."
            return
        }
        
        guard password == confirmPassword else {
            validationErrors["confirmPassword"] = "Passwords do not match"
            return
        }
        
        do {
            let _ = try await userService.register(name: name, login: login, password: password)
            validationErrors = [:]
            onSuccess?()
        } catch let apiError as APIError {
            handleAPIError(apiError)
        } catch {
            self.error = "An unexpected error occurred."
        }
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
                self.error = "Error on input"
            }
        case .unknownError:
            self.error = "An unexpected error occurred."
        }
    }
}

