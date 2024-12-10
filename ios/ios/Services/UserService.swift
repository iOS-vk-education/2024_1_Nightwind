//
//  UserService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation
import SwiftUI

final class UserService {
    private static let JWT_KEYCHAIN_KEY = "com.nightwind.ios.jwt"
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func auth(login: String, password: String) async throws -> String {
        let jwt = try await networkClient.requestRaw(
            UserAPI.authenticateUser(login: login, password: password))
        guard setJwt(jwt) else {
            throw NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to store JWT"])
        }
        return jwt
    }

    func register(name: String, login: String, password: String) async throws -> User {
        return try await networkClient.request(
            UserAPI.registerUser(name: name, login: login, password: password),
            responseType: User.self)
    }

    func logout() {
        clearJwt()
    }
    
    func setJwt(_ token: String) -> Bool {
        guard let data = token.data(using: .utf8) else { return false }

        clearJwt()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: UserService.JWT_KEYCHAIN_KEY,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getJwt() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: UserService.JWT_KEYCHAIN_KEY,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    @discardableResult
    func clearJwt() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: UserService.JWT_KEYCHAIN_KEY
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
