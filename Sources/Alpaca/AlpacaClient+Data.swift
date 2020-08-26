//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation
import OpenCombine

public struct Bar: Codable {
    public enum Timeframe: String, CaseIterable {
        case oneMin = "1Min"
        case fiveMin = "5Min"
        case fifteenMin = "15Min"
        case oneDay = "1D"
    }

    public let t: Double
    public let o: Double
    public let h: Double
    public let l: Double
    public let c: Double
    public let v: Double
}

extension AlpacaClient {

    public func bars(_ timeframe: Bar.Timeframe, symbols: [String], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) -> ResponsePublisher<[String: [Bar]]> {
        return get("bars/\(timeframe.rawValue)", searchParams: [
            "symbols": symbols.joined(separator: ","),
            "limit": limit.map(String.init),
            "start": start.map(Utils.iso8601DateFormatter.string),
            "end": end.map(Utils.iso8601DateFormatter.string),
            "after": after.map(Utils.iso8601DateFormatter.string),
            "until": until.map(Utils.iso8601DateFormatter.string)
        ])
    }

    public func bars(_ timeframe: Bar.Timeframe, symbol: String, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) -> ResponsePublisher<[Bar]> {
        return bars(timeframe, symbols: [symbol], limit: limit, start: start, end: end, after: after, until: until)
            .map { $0[symbol] ?? [] }
            .eraseToAnyPublisher()
    }

    public func bars(_ timeframe: Bar.Timeframe, assets: [Asset], limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) -> ResponsePublisher<[String: [Bar]]> {
        return bars(timeframe, symbols: assets.map(\.symbol), limit: limit, start: start, end: end, after: after, until: until)
    }

    public func bars(_ timeframe: Bar.Timeframe, asset: Asset, limit: Int? = nil, start: Date? = nil, end: Date? = nil, after: Date? = nil, until: Date? = nil) -> ResponsePublisher<[Bar]> {
        return bars(timeframe, symbol: asset.symbol, limit: limit, start: start, end: end, after: after, until: until)
    }
}
