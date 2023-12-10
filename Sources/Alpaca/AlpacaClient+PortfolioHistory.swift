//
//  AlpacaClient+PortfolioHistory.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct PortfolioHistory: Codable {
    public enum Timeframe: String, Codable, CaseIterable {
        case oneMin = "1Min"
        case fiveMin = "5Min"
        case fifteenMin = "15Min"
        case oneHour = "1H"
        case oneDay = "1D"
    }

    public let timestamp: [TimeInterval]
    public let equity: [Double?]
    public let profitLoss: [Double?]
    public let profitLossPct: [Double?]
    public let baseValue: Double?
    public let timeframe: Timeframe?
    
    public init(timestamp: [TimeInterval], equity: [Double], profitLoss: [Double], profitLossPct: [Double], baseValue: Double, timeframe: Timeframe) {
        self.timestamp = timestamp
        self.equity = equity
        self.profitLoss = profitLoss
        self.profitLossPct = profitLossPct
        self.baseValue = baseValue
        self.timeframe = timeframe
    }
}

extension AlpacaClient {
    public func portfolioHistory(period: String? = nil, timeframe: PortfolioHistory.Timeframe? = nil, dateEnd: Date? = nil, extendedHours: Bool? = nil) async throws -> PortfolioHistory {
        return try await get("account/portfolio/history", searchParams: [
            "period": period,
            "timeframe": timeframe?.rawValue,
            "date_end": dateEnd.map(Utils.iso8601DateOnlyFormatter.string),
            "extended_hours": extendedHours.map(String.init)
        ])
    }
}
