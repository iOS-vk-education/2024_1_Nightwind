//
//  NetworkClient.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/10/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Moya

protocol NetworkClient {
    func request<T: Decodable>(
        _ target: TargetType,
        responseType: T.Type
    ) async throws -> T
    
    func requestRaw(
        _ target: TargetType
    ) async throws -> String
}

final class NetworkClientImpl: NetworkClient {
    private let provider: MoyaProvider<MultiTarget>
    
    init(provider: MoyaProvider<MultiTarget> = MoyaProvider<MultiTarget>()) {
        self.provider = provider
    }
    
    func request<T: Decodable>(
        _ target: TargetType,
        responseType: T.Type
    ) async throws -> T {
        let multiTarget = MultiTarget(target)
        let response = try await provider.request(multiTarget)
        return try response.map(T.self)
    }
    
    func requestRaw(
        _ target: TargetType
    ) async throws -> String {
        let multiTarget = MultiTarget(target)
        let response = try await provider.request(multiTarget)
        
        guard let data = String(data: response.data, encoding: .utf8) else {
            throw NSError(domain: "NetworkClientError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert response data to string"])
        }
        return data
    }
}
