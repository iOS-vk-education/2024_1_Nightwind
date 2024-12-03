//
//  PostRepository.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/1/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Moya

final class PostRepository {
    private let provider = MoyaProvider<PostAPI>()

    func get() async throws -> [Post] {
        let response = try await provider.request(.getPosts)
        return try response.map([Post].self)
    }
}

