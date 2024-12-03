//
//  AppState.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/3/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Combine

class AppState: ObservableObject {
    public static var shared = AppState()
    
    private static let JWT_KEYCHAIN_KEY = "com.nightwind.ios.jwt"
    @Published var jwt: String?
    
    init() {
        self.jwt = self.getJwt()
    }
    
    func setJwt(_ token: String) -> Bool {
        guard let data = token.data(using: .utf8) else { return false }

        clearJwt()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: AppState.JWT_KEYCHAIN_KEY,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func getJwt() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: AppState.JWT_KEYCHAIN_KEY,
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

    func clearJwt() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: AppState.JWT_KEYCHAIN_KEY
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
