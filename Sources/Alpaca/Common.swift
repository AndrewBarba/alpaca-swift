//
//  swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation
import NIOHTTP1

public struct EmptyResponse: Decodable {
    internal static let jsonData = try! JSONSerialization.data(withJSONObject: [:], options: [])
}

public enum RequestError: Error {
    case invalidURL
    case status(HTTPResponseStatus)
}

public struct MultiResponse<T>: Codable where T: Codable {
    public let status: Int
    public let body: T
}

public enum SortDirection: String, Codable, CaseIterable {
    case asc = "asc"
    case desc = "desc"
}

public protocol StringRepresentable: CustomStringConvertible {
    init?(_ string: String)
}

extension Double: StringRepresentable {}

extension Float: StringRepresentable {}

extension Int: StringRepresentable {}

public struct NumericString<Value: StringRepresentable>: Codable {
    public var value: Value

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        guard let value = Value(string) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: """
                Failed to convert an instance of \(Value.self) from "\(string)"
                """
            )
        }

        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value.description)
    }
}
