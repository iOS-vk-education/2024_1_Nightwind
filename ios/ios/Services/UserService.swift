//
//  UserService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation
import Moya
import Combine

class UserService {
    private let provider = MoyaProvider<UserRepository>()

    func auth(login: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.authenticateUser(login: login, password: password)) { result in
            switch result {
            case .success(let response):
                let jwt = String(data: response.data, encoding: .utf8)
                self.saveJwt(jwt!)
                completion(.success(jwt!))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func register(name: String, login: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        provider.request(.registerUser(name: name, login: login, password: password)) { result in
            switch result {
            case .success(let response):
                do {
                    let user = try JSONDecoder().decode(User.self, from: response.data)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func logout() {
        clearJwt()
        currentUser = nil
    }

    private func saveJwt(_ token: String) {
        UserDefaults.standard.set(token, forKey: "jwt")
    }

    private func clearJwt() {
        UserDefaults.standard.removeObject(forKey: "jwt")
    }

    func getJwt() -> String? {
        return UserDefaults.standard.string(forKey: "jwt")
    }
}
