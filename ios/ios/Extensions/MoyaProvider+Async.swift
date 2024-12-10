//
//  MoyaProvider+Async.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/3/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Moya

enum APIError: Error {
    case networkError(Error)
    case serverError(Int, [String: String])
    case unknownError

    init(statusCode: Int, validationErrors: [String: String]) {
        self = .serverError(statusCode, [:])
    }
}

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        continuation.resume(returning: filteredResponse)
                    } catch {
                        if let apiError = try? response.map(ErrorResponse.self) {
                            continuation.resume(throwing: APIError(statusCode: response.statusCode, validationErrors: apiError.validationErrors))
                        } else {
                            continuation.resume(throwing: APIError(statusCode: response.statusCode, validationErrors: [:]))
                        }
                    }
                case .failure(let error):
                    continuation.resume(throwing: APIError.networkError(error))
                }
            }
        }
    }
}

struct ErrorResponse: Decodable {
    let validationErrors: [String: String]
}
