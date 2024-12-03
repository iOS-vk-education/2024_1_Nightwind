//
//  DiscussionRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Moya

enum DiscussionAPI {
    case getDiscussionsForPost(postId: Int)
    case createDiscussion(postId: Int, jwt: String, text: String, parentDiscussionId: Int?)
}

extension DiscussionAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://rk.ermnvldmr.com/nightwind")!
    }
    
    var path: String {
        switch self {
        case .getDiscussionsForPost(let postId):
            return "/api/discussions/post/\(postId)"
        case .createDiscussion(let postId, _, _, _):
            return "/api/discussions/post/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDiscussionsForPost:
            return .get
        case .createDiscussion:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getDiscussionsForPost:
            return .requestPlain
        case .createDiscussion(_, let jwt, let text, let parentDiscussionId):
            var params: [String: Any] = ["text": text, "jwt": jwt]
            if let parentId = parentDiscussionId {
                params["parentDiscussionId"] = parentId
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
