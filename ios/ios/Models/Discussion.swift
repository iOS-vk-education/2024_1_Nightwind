//
//  Discussion.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

struct Discussion: Codable {
    let id: Int
    let text: String
    let user: User
    let parentDiscussionId: Int
    let creationTime: String
    let voteCount: Int
}
