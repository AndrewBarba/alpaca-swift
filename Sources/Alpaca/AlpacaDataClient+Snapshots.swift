//
//  File.swift
//  
//
//  Created by Mike Mello on 6/25/23.
//

import Foundation

public struct Snapshot: Codable {
    let latestTrade: Trade
    let latestQuote: Quote
    let minuteBar: Bar
    let dailyBar: Bar
    let prevDailyBar: Bar
    
    public init(latestTrade: Trade, latestQuote: Quote, minuteBar: Bar, dailyBar: Bar, prevDailyBar: Bar) {
        self.latestTrade = latestTrade
        self.latestQuote = latestQuote
        self.minuteBar = minuteBar
        self.dailyBar = dailyBar
        self.prevDailyBar = prevDailyBar
    }
}

extension AlpacaDataClient {
    
    public func snapshots(symbols: [String], feed: Feed = .iex) async throws -> [String: Snapshot] {
        let searchParams: HTTPSearchParams = [
            "symbols": symbols.joined(separator: ","),
            "feed": feed.rawValue
        ]
        return try await get("/stocks/snapshots", searchParams: searchParams)
    }
    
    public func snapshots(assets: [Asset], feed: Feed = .iex) async throws -> [String: Snapshot] {
        return try await snapshots(symbols: assets.map(\.symbol), feed: feed)
    }
}
