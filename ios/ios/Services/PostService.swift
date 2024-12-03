//
//  PostService.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

final class PostService {
    private let postRepository = PostRepository()

    func getPosts() async throws -> [Post] {
        return try await postRepository.get()
    }
}

