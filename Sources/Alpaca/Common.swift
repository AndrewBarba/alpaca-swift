//
//  swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct EmptyResponse: Decodable {
    internal static let jsonData = try! JSONSerialization.data(withJSONObject: [:], options: [])
    enum CodingKeys: CodingKey {
    }
    
    public init(from decoder: Decoder) throws {}
}

public struct ErrorResponse: Decodable {
    internal let code: Int
    internal let message: String
}

public enum Feed: String, CaseIterable {
    case iex = "iex"
    case sip = "sip"
}

public enum RequestError: Error {
    case invalidURL
    case invalidResponse(String)
    case status(Int)
    case unknown(String)
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

    public init(value: Value) {
        self.value = value
    }
    
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

public struct AlpacaError: LocalizedError {
    public var localizedDescription: String {
        get {
            return self.message
        }
    }
    
    public var code: Int?
    public var message: String
    
    init(code: Int?, message: String) {
        self.code = code
        self.message = message
    }
}
