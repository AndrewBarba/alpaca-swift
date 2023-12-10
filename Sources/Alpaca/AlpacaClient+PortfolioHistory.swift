//
//  AlpacaClient+PortfolioHistory.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

/*
 This struct is unusable as-is because there is a known issue with the portfolio history endpoint that leads to incorrect PL and PL% calculations
 so we will calculate those ourselves
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
 */
public struct PortfolioHistory: Decodable {
    public enum CodingKeys: String, CodingKey {
        case timestamp
        case baseValue
        case timeframe
        case equity
        case profitLoss
        case profitLossPct
    }
    public enum Timeframe: String, Codable, CaseIterable {
        case oneMin = "1Min"
        case fiveMin = "5Min"
        case fifteenMin = "15Min"
        case oneHour = "1H"
        case oneDay = "1D"
    }
    public struct Value {
        public let timestamp: TimeInterval
        public let equity: Double
        public let profitLoss: Double
        public let profitLossPct: Double
    }
    public let values: [Value]
    public let baseValue: Double
    public let timeframe: Timeframe
    
    public init(values: [Value], baseValue: Double, timeframe: Timeframe) {
        self.values = values
        self.baseValue = baseValue
        self.timeframe = timeframe
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.baseValue = try container.decode(Double.self, forKey: .baseValue)
        self.timeframe = try container.decode(Timeframe.self, forKey: .timeframe)
        
        let timestamps = try container.decode([TimeInterval].self, forKey: .timestamp)
        let equities = try container.decode([Double?].self, forKey: .equity)
        var values: [Value] = []
        
        for i in 0..<timestamps.count {
            if let equity = equities[i] {
                let pl = equity - baseValue
                let plPct = pl / baseValue
                values.append(.init(timestamp: timestamps[i], equity: equity, profitLoss: pl, profitLossPct: plPct))
            }
        }
        
        self.values = values
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
