//
//  Post.swift
//  Vote
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

struct Vote: Codable {
    let id: Int
    let userId: Int
    let postId: Int?
    let parentDiscussionId: Int?
    let upvote: Bool
}
