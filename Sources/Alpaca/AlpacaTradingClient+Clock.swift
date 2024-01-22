//
//  AlpacaClient+Clock.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct Clock: Codable {
    public let timestamp: Date
    public let isOpen: Bool
    public let nextOpen: Date
    public let nextClose: Date
}

extension AlpacaTradingClient {
    public func clock() async throws -> Clock {
        return try await get("/v2/clock")
    }
}
