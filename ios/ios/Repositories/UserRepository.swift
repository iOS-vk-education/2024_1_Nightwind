//
//  UserRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/1/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Moya
import Foundation

final class UserRepository {
    private let provider = MoyaProvider<UserAPI>()

    func auth(login: String, password: String) async throws -> String {
        let response = try await provider.request(.authenticateUser(login: login, password: password))
        guard let jwt = String(data: response.data, encoding: .utf8) else {
            throw NSError(domain: "UserRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode JWT"])
        }
        return jwt
    }

    func register(name: String, login: String, password: String) async throws -> User {
        let response = try await provider.request(.registerUser(name: name, login: login, password: password))
        return try response.map(User.self)
    }
}

