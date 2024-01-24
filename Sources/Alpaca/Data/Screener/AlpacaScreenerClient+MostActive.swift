//
//  File.swift
//  
//
//  Created by Mike Mello on 1/23/24.
//
import Foundation

public struct MostActive: Codable {
    public enum Metric: String, Codable, CaseIterable {
        case volume
        case trades
    }
    public struct Asset: Codable {
        public let symbol: String
        public let volume: Int64
        public let tradeCount: Int64
    }
    
    public let mostActives: [Asset]
    public let lastUpdated: Date
}

extension AlpacaScreenerClient {
    public func mostActive(by metric: MostActive.Metric, limit: Int = 10) async throws -> MostActive {
        return try await get("/v1beta1/screener/stocks/most-actives", searchParams: ["by": metric.rawValue, "top": "\(limit)"])
    }
}
