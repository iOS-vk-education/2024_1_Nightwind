//
//  MoyaProvider+Async.swift
//  Nightwind
//
//  Created by Vladimir Eremin on 12/3/24.
//  Copyright © 2024 Nightwind Development. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        continuation.resume(returning: response)
                    }
                    catch {
                        do {
                            let errorResponse = try response.map(ErrorResponse.self)
                            let apiError = APIError(statusCode: response.statusCode, validationErrors: errorResponse.validationErrors)
                            continuation.resume(throwing: apiError)
                        }
                        catch(let error) {
                            continuation.resume(throwing: error)
                        }
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

struct ErrorResponse: Decodable {
    let validationErrors: [String: String]
}

struct APIError: Error {
    let statusCode: Int
    let validationErrors: [String: String]
}
