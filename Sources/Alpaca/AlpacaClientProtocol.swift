//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias HTTPSearchParams = [String: String?]

public typealias HTTPBodyParams = [String: Any?]

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case options = "OPTIONS"
}

public protocol AlpacaClientProtocol {
    var api: API { get }
    var timeoutInterval: TimeInterval { get }
}

// MARK: - Requests

extension AlpacaClientProtocol {

    public func get<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.get, urlPath: urlPath, searchParams: searchParams)
    }

    public func delete<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.delete, urlPath: urlPath, searchParams: searchParams)
    }
    
    public func delete(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws {
        return try await request(.delete, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.post, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.post, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func post<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: HTTPBodyParams) async throws -> T where T: Decodable {
        return try await request(.post, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.put, urlPath: urlPath, searchParams: searchParams)
    }

    public func put<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.put, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: HTTPBodyParams) async throws -> T where T: Decodable {
        return try await request(.put, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(.patch, urlPath: urlPath, searchParams: searchParams)
    }

    public func patch<T, V>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        return try await request(.patch, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: HTTPSearchParams? = nil, body: HTTPBodyParams) async throws -> T where T: Decodable {
        return try await request(.patch, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil) async throws -> T where T: Decodable {
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: nil)
    }
    
    public func request(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil) async throws {
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: nil)
    }

    public func request<T, V>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, body: V) async throws -> T where T: Decodable, V: Encodable {
        let data = try Utils.jsonEncoder.encode(body)
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: data)
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, body: HTTPBodyParams) async throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 }, options: [])
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: data)
    }
    
    public func request(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, body: HTTPBodyParams) async throws {
        let data = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 }, options: [])
        return try await request(method, urlPath: urlPath, searchParams: searchParams, httpBody: data)
    }
    
    private func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, httpBody: Data? = nil) async throws -> T where T: Decodable {
        var components = URLComponents()
        components.scheme = "https"
        components.host = api.domain
        components.path = urlPath
        components.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        
        switch api {
        case .paper(authType: let authType):
            authType.authorize(request: &request)
        case .live(authType: let authType):
            authType.authorize(request: &request)
        case .data(authType: let authType):
            authType.authorize(request: &request)
        }

        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("alpaca-swift/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = httpBody
        request.timeoutInterval = timeoutInterval

        #if canImport(FoundationNetworking)
        let (data, _) = try await dataAsync(with: request)
        #else
        #if DEBUG
        Utils.logger.debug("Calling Alpaca: \(request.url?.absoluteString ?? "")")
        #endif
        let (data, _) = try await URLSession.shared.data(for: request)
        #endif

        do {
            return try Utils.jsonDecoder.decode(T.self, from: data)
        } catch {
            //See if it's an error response message first
            if let errorResponse = try? Utils.jsonDecoder.decode(ErrorResponse.self, from: data) {
                throw AlpacaError(code: errorResponse.code, message: errorResponse.message)
            } else {
                //otherwise just rethrow error
                throw error
            }
        }
    }
    
    private func request(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, httpBody: Data? = nil) async throws {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = api.domain
        components.path = urlPath
        components.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        switch api {
        case .paper(authType: let authType):
            authType.authorize(request: &request)
        case .live(authType: let authType):
            authType.authorize(request: &request)
        case .data(authType: let authType):
            authType.authorize(request: &request)
        }

        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("alpaca-swift/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = httpBody
        request.timeoutInterval = timeoutInterval

        #if canImport(FoundationNetworking)
        let (data, response) = try await dataAsync(with: request)
        #else
        let (data, response) = try await URLSession.shared.data(for: request)
        #endif
        
        guard let response = response as? HTTPURLResponse else {
            throw RequestError.unknown("An unknown error occurred. Response is not of expected type")
        }
        
        if !(200..<300 ~= response.statusCode) {
            if let errorResponse = try? Utils.jsonDecoder.decode(ErrorResponse.self, from: data) {
                throw AlpacaError(code: errorResponse.code, message: errorResponse.message)
            }
            throw AlpacaError(code: response.statusCode, message: "An error occurred while attempting the current action")
        }
    }
    
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
