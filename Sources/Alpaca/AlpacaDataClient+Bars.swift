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
        case oneDay = "1Day"
        case threeDay = "3Day"
        case fiveDay = "5Day"
        case oneMonth = "1Month"
        case twelveMonth = "12Month"
    }

    private let t: Double
    public var timeframe: Double { t }

    private let o: Double
    public var open: Double { o }

    private let h: Double
    public var high: Double { h }

    private let l: Double
    public var low: Double { l }

    private let c: Double
    public var close: Double { c }

    private let v: Double
    public var volume: Double { v }
    
    private let n: Double
    public var numTrades: Double { n }
    
    private let vw: Double
    public var volWeightedAvgPrice: Double { vw }
}

extension AlpacaDataClient {

    public func bars(_ timeframe: Bar.Timeframe, symbols: [String], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [String: [String: [Bar]]] {
        return try await get("stocks/bars", searchParams: [
            "symbols": symbols.joined(separator: ","),
            "limit": limit.map(String.init),
            "start": start.map(Utils.iso8601DateOnlyFormatter.string),
            "end": end.map(Utils.iso8601DateFormatter.string),
            "after": after.map(Utils.iso8601DateFormatter.string),
            "until": until.map(Utils.iso8601DateFormatter.string),
            "timeframe": timeframe.rawValue
        ])
    }

    public func bars(_ timeframe: Bar.Timeframe, symbol: String, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [Bar] {
        let res = try await bars(timeframe, symbols: [symbol], limit: limit, start: start, end: end, after: after, until: until)
        return res["bars", default: [:]][symbol, default: []]
    }

    public func bars(_ timeframe: Bar.Timeframe, assets: [Asset], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [String: [Bar]] {
        return try await bars(timeframe, symbols: assets.map(\.symbol), limit: limit, start: start, end: end, after: after, until: until)["bars", default: [:]]
    }

    public func bars(_ timeframe: Bar.Timeframe, asset: Asset, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) async throws -> [Bar] {
        return try await bars(timeframe, symbol: asset.symbol, limit: limit, start: start, end: end, after: after, until: until)
    }
}
