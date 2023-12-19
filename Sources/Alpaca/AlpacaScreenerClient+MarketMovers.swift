//
//  File.swift
//  
//
//  Created by Mike Mello on 12/18/23.
//

import Foundation

public enum MarketType: String, Codable {
    case stocks
    case crypto
}

public struct MarketMover: Codable {
    public let symbol: String
    public let price: Double
    public let change: Double
    public let percentChange: Double
}

public struct MarketMovers: Codable {
    public let gainers: [MarketMover]
    public let losers: [MarketMover]
    public let marketType: MarketType
    public let lastUpdated: Date
}

extension AlpacaScreenerClient {
    public func marketMovers(type: MarketType, limit: Int = 10) async throws -> MarketMovers {
        return try await get("screener/\(type.rawValue)/movers", searchParams: ["top": "\(limit)"])
    }
}
