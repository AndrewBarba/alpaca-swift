//
//  AlpacaClient+AccountConfiguration.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct AccountConfiguration: Codable {
    public enum DayTradeBuyingPowerCheck: String, Codable, CaseIterable {
        case both = "both"
        case entry = "entry"
        case exit = "exit"
    }

    public enum TradeConfirmEmail: String, Codable, CaseIterable {
        case all = "all"
        case none = "none"
    }
    
    public enum PatterDayTraderCheck: String, Codable, CaseIterable {
        case both = "both"
        case entry = "entry"
        case exit = "exit"
    }

    public var dtbpCheck: DayTradeBuyingPowerCheck
    public var pdtCheck: PatterDayTraderCheck
    public var noShorting: Bool
    public var suspendTrade: Bool
    public var fractionalTrading: Bool
    public var tradeConfirmEmail: TradeConfirmEmail
    
    public init(dtbpCheck: DayTradeBuyingPowerCheck, pdtCheck: PatterDayTraderCheck, noShorting: Bool, suspendTrade: Bool, fractionalTrading: Bool, tradeConfirmEmail: TradeConfirmEmail) {
        self.dtbpCheck = dtbpCheck
        self.pdtCheck = pdtCheck
        self.noShorting = noShorting
        self.suspendTrade = suspendTrade
        self.fractionalTrading = fractionalTrading
        self.tradeConfirmEmail = tradeConfirmEmail
    }
}

extension AlpacaTradingClient {
    public func accountConfigurations() async throws -> AccountConfiguration {
        return try await get("/v2/account/configurations")
    }

    public func saveAccountConfigurations(_ configuration: AccountConfiguration) async throws -> AccountConfiguration {
        return try await patch("/v2/account/configurations", body: configuration)
    }

    public func saveAccountConfigurations(dtbpCheck: AccountConfiguration.DayTradeBuyingPowerCheck? = nil, pdtCheck: AccountConfiguration.PatterDayTraderCheck? = nil, noShorting: Bool? = nil, suspendTrade: Bool? = nil, fractionalTrading: Bool? = nil, tradeConfirmEmail: AccountConfiguration.TradeConfirmEmail? = nil) async throws -> AccountConfiguration {
        return try await patch("/v2/account/configurations", body: [
            "dtbp_check": dtbpCheck?.rawValue,
            "pdt_check": pdtCheck?.rawValue,
            "no_shorting": noShorting,
            "suspend_trade": suspendTrade,
            "fractional_trading": fractionalTrading,
            "trade_confirm_email": tradeConfirmEmail?.rawValue
        ])
    }
}
