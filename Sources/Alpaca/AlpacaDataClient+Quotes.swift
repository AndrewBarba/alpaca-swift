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
    
    private let ap: Double
    public var askPrice: Double { ap }
    
    private let `as`: Int
    public var askSize: Int { `as` }
    
    private let bx: String
    public var bidExchange: String { bx }
    
    private let bp: Double
    public var bidPrice: Double { bp }
    
    private let bs: Int
    public var bidSize: Int { bs }
    
    private let c: [String]
    public var conditions: [String] { c }
    
    private let z: String?
    public var tape: String? { z }
    
    public init(t: Date, ax: String, ap: Double, as: Int, bx: String, bp: Double, bs: Int, c: [String], z: String?) {
        self.t = t
        self.ax = ax
        self.ap = ap
        self.as = `as`
        self.bx = bx
        self.bp = bp
        self.bs = bs
        self.c = c
        self.z = z
    }
}

struct LatestQuoteResponse: Codable {
    let symbol: String
    let quote: Quote
    
    public init(symbol: String, quote: Quote) {
        self.symbol = symbol
        self.quote = quote
    }
}


extension AlpacaDataClient {
    
    public func latestQuote(symbol: String, feed: Feed = .iex) async throws -> Quote {
        let searchParams: HTTPSearchParams = [
            "feed": feed.rawValue
        ]
        
        let response: LatestQuoteResponse = try await get("stocks/\(symbol)/quotes/latest", searchParams: searchParams)
        return response.quote
    }
    
    public func latestQuote(asset: Asset, feed: Feed = .iex) async throws -> Quote {
        return try await latestQuote(symbol: asset.symbol, feed: feed)
    }
}
