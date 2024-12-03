//
//  User.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let login: String
    let admin: Bool?
    let creationTime: String
}
