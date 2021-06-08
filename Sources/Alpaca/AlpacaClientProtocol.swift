//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import AsyncHTTPClient
import Foundation
import NIO
import NIOHTTP1

public protocol AlpacaClientProtocol {
    typealias SearchParams = [String: String?]

    typealias BodyParams = [String: Any?]

    var environment: Environment { get }
}

// MARK: - Requests

extension AlpacaClientProtocol {

    public func get<T>(_ urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.GET, urlPath: urlPath, searchParams: searchParams)
    }

    public func delete<T>(_ urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.DELETE, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T>(_ urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.POST, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.POST, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func post<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) async throws -> T where T: Decodable {
        return try await request(.POST, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.PUT, urlPath: urlPath, searchParams: searchParams)
    }

    public func put<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.PUT, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) async throws -> T where T: Decodable {
        return try await request(.PUT, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.PATCH, urlPath: urlPath, searchParams: searchParams)
    }

    public func patch<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.PATCH, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) async throws -> T where T: Decodable {
        return try await request(.PATCH, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(method, urlPath: urlPath, searchParams: searchParams, body: nil)
    }

    public func request<T, V>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        let data = try Utils.jsonEncoder.encode(body)
        return try await request(method, urlPath: urlPath, searchParams: searchParams, body: .data(data))
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) async throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 }, options: [])
        return try await request(method, urlPath: urlPath, searchParams: searchParams, body: .data(data))
    }

    private func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: HTTPClient.Body? = nil) async throws -> T where T: Decodable {
        var components = URLComponents(string: "\(environment.api)/\(urlPath)")
        components?.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components?.url else {
            throw RequestError.invalidURL
        }

        let headers = HTTPHeaders([
            ("APCA-API-KEY-ID", self.environment.key),
            ("APCA-API-SECRET-KEY", self.environment.secret),
            ("Content-Type", "application/json"),
            ("User-Agent", "alpaca-swift/1.0")
        ])

        let httpRequest = try HTTPClient.Request(url: url, method: method, headers: headers, body: body)

        return try await request(httpRequest)
    }

    private func request<T>(_ httpRequest: HTTPClient.Request) async throws -> T where T: Decodable {
        await withUnsafeContinuation { promise in
            let req = Utils.httpClient.execute(request: httpRequest)

            req.whenSuccess { res in
                do {
                    guard (200..<300).contains(response.status.code) else {
                        throw RequestError.status(response.status)
                    }
                    guard let body = response.body, let bytes = body.getBytes(at: 0, length: body.readableBytes) else {
                        promise.resume(returning: try Utils.jsonDecoder.decode(T.self, from: EmptyResponse.jsonData))
                        return
                    }
                    let data = Data(bytes)
                    promise.resume(returning: try Utils.jsonDecoder.decode(T.self, from: data))
                } catch {
                    promise.resume(throwing: error)
                }
            }

            req.whenFailure { error in
                promise.resume(throwing: error)
            }
        }
    }
}
