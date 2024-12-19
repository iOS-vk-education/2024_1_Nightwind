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
    
    private var post: Post = Post(
        id: 1,
        title: "New Episode!",
        text: """
Just wrapped up the latest episode of Aerial Girl Squad! Watching it come to life from the storyboards to the final scenes has been such a rewarding experience.
""",
        user: User(id: 1, name: "Ema Yasuhara", login: "emmya", admin: nil, creationTime: "2024-10-07"),
        viewCount: 6941,
        creationTime: "2:24 07 Oct 24",
        voteCount: 1336,
        disscussion: [
            Discussion(
                id: 1,
                text: "This episode was amazing!",
                user: User(id: 2, name: "John Doe", login: "johndoe", admin: nil, creationTime: "2024-10-07"),
                parentDiscussionId: 0,
                creationTime: "2:30 07 Oct 24",
                voteCount: 45
            )
        ]
    )

    func getPosts() -> [Post] {
        return [post, post, post, post, post]
//        return try await networkClient.request(
//            PostAPI.getPosts,
//            responseType: [Post].self)
    }
}

