//
//  AppState.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/3/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Combine

class AppState: ObservableObject {
    private static let networkClient = NetworkClientImpl()
    
    public static let userService = UserService(networkClient: AppState.networkClient)
    
    public static let postService = PostService(networkClient: AppState.networkClient)
}
