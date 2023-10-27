//
//  AlpacaClient+AccountConfiguration.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct AccountConfigurations: Codable {
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

extension AlpacaClient {
    public func accountConfigurations() async throws -> AccountConfigurations {
        return try await get("account/configurations")
    }

    public func saveAccountConfigurations(_ configurations: AccountConfigurations) async throws -> AccountConfigurations {
        return try await patch("account/configurations", body: configurations)
    }

    public func saveAccountConfigurations(dtbpCheck: AccountConfigurations.DayTradeBuyingPowerCheck? = nil, pdtCheck: AccountConfigurations.PatterDayTraderCheck? = nil, noShorting: Bool? = nil, suspendTrade: Bool? = nil, fractionalTrading: Bool? = nil, tradeConfirmEmail: AccountConfigurations.TradeConfirmEmail? = nil) async throws -> AccountConfigurations {
        return try await patch("account/configurations", body: [
            "dtbp_check": dtbpCheck?.rawValue,
            "pdt_check": pdtCheck?.rawValue,
            "no_shorting": noShorting,
            "suspend_trade": suspendTrade,
            "fractional_trading": fractionalTrading,
            "trade_confirm_email": tradeConfirmEmail?.rawValue
        ])
    }
}
