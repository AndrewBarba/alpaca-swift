//
//  File.swift
//  
//
//  Created by Mike Mello on 1/24/24.
//

import Foundation

public struct Snapshot: Codable {
    public let latestTrade: Trade
    public let latestQuote: Quote
    public let minuteBar: Bar
    public let dailyBar: Bar
    public let prevDailyBar: Bar
    
    public init(latestTrade: Trade, latestQuote: Quote, minuteBar: Bar, dailyBar: Bar, prevDailyBar: Bar) {
        self.latestTrade = latestTrade
        self.latestQuote = latestQuote
        self.minuteBar = minuteBar
        self.dailyBar = dailyBar
        self.prevDailyBar = prevDailyBar
    }
}

extension AlpacaDataClient.StocksClient {
    
    public func snapshots(symbols: [String], feed: Feed = .iex) async throws -> [String: Snapshot] {
        let searchParams: HTTPSearchParams = [
            "symbols": symbols.joined(separator: ","),
            "feed": feed.rawValue
        ]
        return try await get("/v2/stocks/snapshots", searchParams: searchParams)
    }
    
    public func snapshots(assets: [Asset], feed: Feed = .iex) async throws -> [String: Snapshot] {
        return try await snapshots(symbols: assets.map(\.symbol), feed: feed)
    }
}
