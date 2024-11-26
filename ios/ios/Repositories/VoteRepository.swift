//
//  VoteRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 11/26/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation

import Moya

enum VoteRepository {
    case getPostVote(postId: Int, jwt: String)
    case votePost(postId: Int, jwt: String, upvote: Bool)
    case getDiscussionVote(discussionId: Int, jwt: String)
    case voteDiscussion(discussionId: Int, jwt: String, upvote: Bool)
}

extension VoteRepository: TargetType {
    var baseURL: URL {
        return URL(string: "https://rk.ermnvldmr.com/nightwind")!
    }
    
    var path: String {
        switch self {
        case .getPostVote(let postId, _):
            return "/api/votes/post/\(postId)"
        case .votePost(let postId, _, _):
            return "/api/votes/post/\(postId)"
        case .getDiscussionVote(let discussionId, _):
            return "/api/votes/discussion/\(discussionId)"
        case .voteDiscussion(let discussionId, _, _):
            return "/api/votes/discussion/\(discussionId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPostVote, .getDiscussionVote:
            return .get
        case .votePost, .voteDiscussion:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPostVote(_, let jwt), .getDiscussionVote(_, let jwt):
            return .requestParameters(parameters: ["jwt": jwt], encoding: URLEncoding.queryString)
        case .votePost(_, let jwt, let upvote), .voteDiscussion(_, let jwt, let upvote):
            return .requestParameters(parameters: ["jwt": jwt, "upvote": upvote], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
