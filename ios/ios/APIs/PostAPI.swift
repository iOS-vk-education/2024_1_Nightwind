//
//  PostRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Moya

enum PostAPI {
    case getPosts
    case createPost(jwt: String, title: String, text: String)
    case getPostById(postId: Int)
}

extension PostAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://rk.ermnvldmr.com/nightwind")!
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/api/posts"
        case .getPostById(let postId):
            return "/api/posts/\(postId)"
        case .createPost:
            return "/api/posts"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPosts, .getPostById:
            return .get
        case .createPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPosts:
            return .requestPlain
        case .getPostById(_):
            return .requestPlain
        case .createPost(let jwt, let title, let text):
            let params: [String: Any] = ["title": title, "text": text]
            return .requestCompositeParameters(bodyParameters: params, bodyEncoding: JSONEncoding.default, urlParameters: ["jwt": jwt])
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
