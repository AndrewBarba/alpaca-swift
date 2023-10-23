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
    var environment: Environment { get }
    
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
        var components = URLComponents(string: "\(environment.api)/\(urlPath)")
        components?.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components?.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        if case .oauth(let accessToken) = environment.authType {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if case .basic(let key, let secret) = environment.authType {
            request.setValue(key, forHTTPHeaderField: "APCA-API-KEY-ID")
            request.setValue(secret, forHTTPHeaderField: "APCA-API-SECRET-KEY")
        }
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("alpaca-swift/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = httpBody
        request.timeoutInterval = timeoutInterval

        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            return try Utils.jsonDecoder.decode(T.self, from: data)
        } catch {
            if let error = error as? DecodingError {
                // rethrow the error if it's a decoding error
                // because it's not even valid json
                throw error
            } else {
                //else let's try to throw an error with the returned message from Alpaca
                if let errorResponse = try? Utils.jsonDecoder.decode(ErrorResponse.self, from: data) {
                    throw AlpacaError(code: errorResponse.code, message: errorResponse.message)
                } else {
                    //if we failed to get decode the error response something else must be wrong. Rethrow
                    throw error
                }
            }
        }
    }
    
    private func request(_ method: HTTPMethod, urlPath: String, searchParams: HTTPSearchParams? = nil, httpBody: Data? = nil) async throws {
        var components = URLComponents(string: "\(environment.api)/\(urlPath)")
        components?.queryItems = searchParams?.compactMapValues { $0 }.map(URLQueryItem.init)

        guard let url = components?.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        if case .oauth(let accessToken) = environment.authType {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if case .basic(let key, let secret) = environment.authType {
            request.setValue(key, forHTTPHeaderField: "APCA-API-KEY-ID")
            request.setValue(secret, forHTTPHeaderField: "APCA-API-SECRET-KEY")
        }
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("alpaca-swift/1.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = httpBody
        request.timeoutInterval = timeoutInterval

        let (data, response) = try await URLSession.shared.data(for: request)
        
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
}
