//
//  VoteService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

final class VoteService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    @discardableResult
    func votePost(postId: Int, jwt: String, upvote: Bool) async throws -> Vote? {
        let response = try await networkClient.requestRaw(
            VoteAPI.votePost(postId: postId, jwt: jwt, upvote: upvote))
        
        return response.data.isEmpty ? nil : try response.map(Vote.self)
    }
    
    @discardableResult
    func voteDiscussion(discussionId: Int, jwt: String, upvote: Bool) async throws -> Vote? {
        let response = try await networkClient.requestRaw(
            VoteAPI.voteDiscussion(discussionId: discussionId, jwt: jwt, upvote: upvote))
        
        return response.data.isEmpty ? nil : try response.map(Vote.self)
    }
    
    func getPostVote(postId: Int, jwt: String) async throws -> Vote? {
        let response = try await networkClient.requestRaw(VoteAPI.getPostVote(postId: postId, jwt: jwt))
        
        return response.data.isEmpty ? nil : try response.map(Vote.self)
    }
    
    func getDiscussionVote(discussionId: Int, jwt: String) async throws -> Vote? {
        let response = try await networkClient.requestRaw(VoteAPI.getDiscussionVote(discussionId: discussionId, jwt: jwt))
        
        return response.data.isEmpty ? nil : try response.map(Vote.self)
    }
}

