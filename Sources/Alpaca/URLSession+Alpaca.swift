//
//  File.swift
//  
//
//  Created by Mike Mello on 11/11/23.
//

import Foundation

extension URLSession {
    func dataAsync(with request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                guard let data else {
                    continuation.resume(throwing: RequestError.unknown("Nil data"))
                    return
                }
                guard let response else {
                    continuation.resume(throwing: RequestError.unknown("Nil response"))
                    return
                }
                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
}
