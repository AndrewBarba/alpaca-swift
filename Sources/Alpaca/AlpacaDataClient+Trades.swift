//
//  File.swift
//  
//
//  Created by Mike Mello on 6/23/23.
//

import Foundation

public struct Trade: Codable {
    private let t: Date
    public var timestamp: Date { t }
    
    private let x: String
    public var exchange: String { x }
    
    private let p: Double
    public var price: Double { p }
    
    private let s: Int
    public var size: Int { s }
    
    private let c: [String]
    public var conditions: [String] { c }
    
    private let i: Int
    public var id: Int { i }
    
    private let z: String
    public var tape: String { z }
    
    private let u: String?
    public var update: String? { u }
    
    public enum Feed: String, CaseIterable {
        case iex = "iex"
        case sip = "sip"
    }
}

struct TradesResponse: Codable {
    let trades: [String: [Trade]]
    let nextPageToken: String?
}

extension AlpacaDataClient {
    public func trades(symbols: [String], start: Date? = nil, end: Date? = nil, limit: Int? = nil, asof: Date? = nil, feed: Trade.Feed = .iex) async throws -> [String: [Trade]] {
        var searchParams: HTTPSearchParams = [
            "symbols": symbols.joined(separator: ","),
            "start": start.map(Utils.iso8601DateFormatter.string),
            "end": end.map(Utils.iso8601DateFormatter.string),
            "limit": limit.map(String.init),
            "asof": asof.map(Utils.iso8601DateOnlyFormatter.string),
            "feed": feed.rawValue
        ]
        
        var response: TradesResponse = try await get("/v2/stocks/trades", searchParams: searchParams)
        var trades = response.trades
        while let pageToken = response.nextPageToken {
            searchParams["page_token"] = pageToken
            response = try await get("/stocks/trades", searchParams: searchParams)
            response.trades.forEach {
                trades[$0]?.append(contentsOf: $1)
            }
        }
        
        return trades
    }
    
    public func trades(assets: [Asset], start: Date? = nil, end: Date? = nil, limit: Int? = nil, asof: Date? = nil, feed: Trade.Feed = .iex) async throws -> [String: [Trade]] {
        return try await trades(symbols: assets.map(\.symbol), start: start, end: end, limit: limit, asof: asof, feed: feed)
    }
    
    public func trades(asset: Asset, start: Date? = nil, end: Date? = nil, limit: Int? = nil, asof: Date? = nil, feed: Trade.Feed = .iex) async throws ->  [Trade] {
        return try await trades(symbol: asset.symbol, start: start, end: end, limit: limit, asof: asof, feed: feed)
    }
    
    public func trades(symbol: String, start: Date? = nil, end: Date? = nil, limit: Int? = nil, asof: Date? = nil, feed: Trade.Feed = .iex) async throws ->  [Trade] {
        let res = try await trades(symbols: [symbol], start: start, end: end, limit: limit, asof: asof, feed: feed)
        return res[symbol, default: []]
    }
}
