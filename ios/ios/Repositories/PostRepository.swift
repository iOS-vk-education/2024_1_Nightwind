//
//  PostRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Moya

enum PostRepository {
    case getPosts
    case createPost(jwt: String, title: String, text: String)
}

extension PostRepository: TargetType {
    var baseURL: URL {
        return URL(string: "http://rk.ermnvldmr.com/nightwind")!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/api/posts"
        case .createPost:
            return "/api/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts:
            return .requestPlain
        case .createPost(let jwt, let title, let text):
            var params: [String: Any] = ["title": title, "text": text]
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: ["jwt": jwt])
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
