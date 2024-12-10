//
//  PostService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

final class PostService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getPosts() async throws -> [Post] {
        return try await networkClient.request(
            PostAPI.getPosts,
            responseType: [Post].self)
    }
}

