//
//  Post.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let text: String
    let user: User
    let viewCount: Int
    let creationTime: String
    let voteCount: Int
}
