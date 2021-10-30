//
//  AlpacaClient+Positions.swift
//  
//
//  Created by Andrew Barba on 8/16/20.
//

import Foundation

public struct Position: Codable {
    public enum Side: String, Codable, CaseIterable {
        case long = "long"
        case short = "short"
    }

    public let assetId: UUID
    public let symbol: String
    public let exchange: Asset.Exchange
    public let assetClass: Asset.Class
    public let avgEntryPrice: NumericString<Double>
    public let qty: NumericString<Double>
    public let side: Side
    public let marketValue: NumericString<Double>
    public let costBasis: NumericString<Double>
    public let unrealizedPl: NumericString<Double>
    public let unrealizedPlpc: NumericString<Double>
    public let unrealizedIntradayPl: NumericString<Double>
    public let unrealizedIntradayPlpc: NumericString<Double>
    public let currentPrice: NumericString<Double>
    public let lastdayPrice: NumericString<Double>
    public let changeToday: NumericString<Double>
}

extension AlpacaClient {
    public func positions() async throws -> [Position] {
        return try await get("positions")
    }

    public func position(assetId: String) async throws -> Position {
        return try await get("positions/\(assetId)")
    }

    public func position(assetId: UUID) async throws -> Position {
        return try await get("positions/\(assetId.uuidString)")
    }

    public func position(symbol: String) async throws -> Position {
        return try await get("positions/\(symbol)")
    }

    public func closePositions() async throws -> [MultiResponse<Order>] {
        return try await delete("positions")
    }

    public func closePosition(assetId: String) async throws -> Order {
        return try await delete("positions/\(assetId)")
    }

    public func closePosition(assetId: UUID) async throws -> Order {
        return try await delete("positions/\(assetId.uuidString)")
    }

    public func closePosition(symbol: String) async throws -> Order {
        return try await delete("positions/\(symbol)")
    }
}
