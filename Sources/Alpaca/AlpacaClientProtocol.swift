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
import OpenCombine

public protocol AlpacaClientProtocol {
    typealias ResponsePublisher<T: Decodable> = AnyPublisher<T, Error>

    typealias EmptyResponsePublisher = ResponsePublisher<EmptyResponse>

    typealias SearchParams = [String: String?]

    typealias BodyParams = [String: Any?]

    var environment: Environment { get }
}

// MARK: - Requests

extension AlpacaClientProtocol {

    public func get<T>(_ urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(.GET, urlPath: urlPath, searchParams: searchParams)
    }

    public func delete<T>(_ urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(.DELETE, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T>(_ urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(.POST, urlPath: urlPath, searchParams: searchParams)
    }

    public func post<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) -> ResponsePublisher<T> where T: Decodable, V: Encodable {
        request(.POST, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func post<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) -> ResponsePublisher<T> where T: Decodable {
        request(.POST, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(.PUT, urlPath: urlPath, searchParams: searchParams)
    }

    public func put<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) -> ResponsePublisher<T> where T: Decodable, V: Encodable {
        request(.PUT, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func put<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) -> ResponsePublisher<T> where T: Decodable {
        request(.PUT, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(.PATCH, urlPath: urlPath, searchParams: searchParams)
    }

    public func patch<T, V>(_ urlPath: String, searchParams: SearchParams? = nil, body: V) -> ResponsePublisher<T> where T: Decodable, V: Encodable {
        request(.PATCH, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func patch<T>(_ urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) -> ResponsePublisher<T> where T: Decodable {
        request(.PATCH, urlPath: urlPath, searchParams: searchParams, body: body)
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil) -> ResponsePublisher<T> where T: Decodable {
        return request(method, urlPath: urlPath, searchParams: searchParams, body: nil)
    }

    public func request<T, V>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: V) -> ResponsePublisher<T> where T: Decodable, V: Encodable {
        do {
            let data = try Utils.jsonEncoder.encode(body)
            return request(method, urlPath: urlPath, searchParams: searchParams, body: .data(data))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    public func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: BodyParams) -> ResponsePublisher<T> where T: Decodable {
        do {
            let data = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 }, options: [])
            return request(method, urlPath: urlPath, searchParams: searchParams, body: .data(data))
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func request<T>(_ method: HTTPMethod, urlPath: String, searchParams: SearchParams? = nil, body: HTTPClient.Body? = nil) -> ResponsePublisher<T> where T: Decodable {
        do {
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

            return request(httpRequest)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func request<T>(_ httpRequest: HTTPClient.Request) -> ResponsePublisher<T> where T: Decodable {
        Future<HTTPClient.Response, Error> { resolver in
            Utils.httpClient.execute(request: httpRequest).whenComplete(resolver)
        }
            .tryMap { response in
                guard (200..<300).contains(response.status.code) else {
                    throw RequestError.status(response.status)
                }
                guard let body = response.body, let bytes = body.getBytes(at: 0, length: body.readableBytes) else {
                    return try Utils.jsonDecoder.decode(T.self, from: EmptyResponse.jsonData)
                }
                let data = Data(bytes)
                return try Utils.jsonDecoder.decode(T.self, from: data)
            }
            .eraseToAnyPublisher()
    }
}
