//
//  Post.swift
//  Vote
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

struct Vote: Codable {
    let id: Int
    let user: User
    let post: Post?
    let discussion: Discussion?
    let upvote: Bool
    let valid: Bool
}
