//
//  File.swift
//  
//
//  Created by Mike Mello on 6/24/23.
//

import Foundation

public struct Quote: Codable {
    private let t: Date
    public var timestamp: Date { t }
    
    private let ax: String
    public var askExchange: String { ax }
    
    private let ap: NumericString<Double>
    public var askPrice: NumericString<Double> { ap }
    
    private let `as`: Int
    public var askSize: Int { `as` }
    
    private let bx: String
    public var bidExchange: String { bx }
    
    private let bp: NumericString<Double>
    public var bidPrice: NumericString<Double> { bp }
    
    private let bs: Int
    public var bidSize: Int { bs }
    
    private let c: [String]
    public var conditions: [String] { c }
    
    private let z: String?
    public var tape: String? { z }
    
    public enum Feed: String, CaseIterable {
        case iex = "iex"
        case sip = "sip"
    }
}

struct LatestQuoteResponse: Codable {
    let symbol: String
    let quote: Quote
}


extension AlpacaDataClient {
    
    public func latestQuote(symbol: String, feed: Quote.Feed = .iex) async throws -> Quote {
        let searchParams: HTTPSearchParams = [
            "symbols": symbol,
            "feed": feed.rawValue
        ]
        
        let response: LatestQuoteResponse = try await get("/stocks/\(symbol)/quotes/latest", searchParams: searchParams)
        return response.quote
    }
    
    public func latestQuote(asset: Asset, feed: Quote.Feed = .iex) async throws -> Quote {
        return try await latestQuote(symbol: asset.symbol, feed: feed)
    }
}
