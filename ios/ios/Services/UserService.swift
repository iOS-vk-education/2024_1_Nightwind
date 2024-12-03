//
//  UserService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation
import SwiftUI

final class UserService {
    private let userRepository = UserRepository()
    
    private let appState = AppState.shared;
    
    func auth(login: String, password: String) async throws -> String {
        let jwt = try await userRepository.auth(login: login, password: password)
        guard appState.setJwt(jwt) else {
            throw NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to store JWT"])
        }
        return jwt
    }

    func register(name: String, login: String, password: String) async throws -> User {
        return try await userRepository.register(name: name, login: login, password: password)
    }

    func logout() {
        appState.clearJwt()
    }
    
    func getJwt() -> String? {
        return appState.jwt
    }
}
