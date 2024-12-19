//
//  DiscussionService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

final class DiscussionService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getDiscussionsForPost(postId: Int) async throws -> [Discussion] {
        return try await networkClient.request(
            DiscussionAPI.getDiscussionsForPost(postId: postId),
            responseType: [Discussion].self)
    }
    
    @discardableResult
    func postDiscussion(postId: Int, jwt: String, discussion: DiscussionForm, parentDiscussionId: Int?) async throws -> Discussion {
        return try await networkClient.request(
            DiscussionAPI.createDiscussion(postId: postId, jwt: jwt, discussion: discussion, parentDiscussionId: parentDiscussionId), responseType: Discussion.self)
    }
        
}

