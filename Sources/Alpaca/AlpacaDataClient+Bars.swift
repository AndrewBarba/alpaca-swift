//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public struct Bar: Codable {
    public enum Timeframe: String, CaseIterable {
        case oneMin = "1Min"
        case fiveMin = "5Min"
        case fifteenMin = "15Min"
        case oneHour = "1Hour"
        case oneDay = "1Day"
        case oneWeek = "1Week"
        case oneMonth = "1Month"
    }

    private let t: Date
    public var timestamp: Date { t }

    private let o: Double
    public var open: Double { o }

    private let h: Double
    public var high: Double { h }

    private let l: Double
    public var low: Double { l }

    private let c: Double
    public var close: Double { c }

    private let v: Int64
    public var volume: Int64 { v }
    
    private let n: Int64
    public var numTrades: Int64 { n }
    
    private let vw: Double
    public var volWeightedAvgPrice: Double { vw }
    
    public init(t: Date, o: Double, h: Double, l: Double, c: Double, v: Int64, n: Int64, vw: Double) {
        self.t = t
        self.o = o
        self.h = h
        self.l = l
        self.c = c
        self.v = v
        self.n = n
        self.vw = vw
    }
}

struct BarResponse: Codable {
    let bars: [String: [Bar]]
    let nextPageToken: String?
}

extension AlpacaDataClient {

    public func bars(_ timeframe: Bar.Timeframe, symbols: [String], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [String: [Bar]] {
        var searchParams: HTTPSearchParams = [
            "symbols": symbols.joined(separator: ","),
            "limit": limit.map(String.init),
            "start": start.map(Utils.iso8601DateFormatter.string),
            "end": end.map(Utils.iso8601DateFormatter.string),
            "after": after.map(Utils.iso8601DateFormatter.string),
            "until": until.map(Utils.iso8601DateFormatter.string),
            "timeframe": timeframe.rawValue
        ]
        var response: BarResponse = try await get("stocks/bars", searchParams: searchParams)
        var bars = response.bars
        while let pageToken = response.nextPageToken {
            searchParams["page_token"] = pageToken
            response = try await get("stocks/bars", searchParams: searchParams)
            response.bars.forEach {
                bars[$0]?.append(contentsOf: $1)
            }
        }
        
        return bars
    }

    public func bars(_ timeframe: Bar.Timeframe, symbol: String, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [Bar] {
        let res = try await bars(timeframe, symbols: [symbol], limit: limit, start: start, end: end, after: after, until: until)
        return res[symbol, default: []]
    }

    public func bars(_ timeframe: Bar.Timeframe, assets: [Asset], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [String: [Bar]] {
        return try await bars(timeframe, symbols: assets.map(\.symbol), limit: limit, start: start, end: end, after: after, until: until)
    }

    public func bars(_ timeframe: Bar.Timeframe, asset: Asset, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [Bar] {
        return try await bars(timeframe, symbol: asset.symbol, limit: limit, start: start, end: end, after: after, until: until)
    }
}
