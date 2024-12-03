//
//  UserRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Moya

enum UserAPI {
    case registerUser(name: String, login: String, password: String)
    case authenticateUser(login: String, password: String)
    case getUserByJWT(jwt: String)
    case getAllUsers
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://rk.ermnvldmr.com/nightwind")!
    }
    
    var path: String {
        switch self {
        case .registerUser:
            return "/api/users/register"
        case .authenticateUser:
            return "/api/users/enter"
        case .getUserByJWT:
            return "/api/users/jwt"
        case .getAllUsers:
            return "/api/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerUser, .authenticateUser:
            return .post
        case .getUserByJWT, .getAllUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .registerUser(let name, let login, let password):
            let params = ["name": name, "login": login, "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .authenticateUser(let login, let password):
            let params = ["login": login, "password": password]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getUserByJWT(let jwt):
            return .requestParameters(parameters: ["jwt": jwt], encoding: URLEncoding.queryString)
        case .getAllUsers:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
