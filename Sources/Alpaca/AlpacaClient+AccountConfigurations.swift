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

    public var dtbpCheck: DayTradeBuyingPowerCheck
    public var noShorting: Bool
    public var suspendTrade: Bool
    public var tradeConfirmEmail: TradeConfirmEmail
}

extension AlpacaClient {
    public func accountConfigurations() async throws -> AccountConfigurations {
        return try await get("account/configurations")
    }

    public func saveAccountConfigurations(_ configurations: AccountConfigurations) async throws -> AccountConfigurations {
        return try await patch("account/configurations", body: configurations)
    }

    public func saveAccountConfigurations(dtbpCheck: AccountConfigurations.DayTradeBuyingPowerCheck? = nil, noShorting: Bool? = nil, suspendTrade: Bool? = nil, tradeConfirmEmail: AccountConfigurations.TradeConfirmEmail? = nil) async throws -> AccountConfigurations {
        return try await patch("account/configurations", body: [
            "dtbp_check": dtbpCheck?.rawValue,
            "no_shorting": noShorting,
            "suspend_trade": suspendTrade,
            "trade_confirm_email": tradeConfirmEmail?.rawValue
        ])
    }
}
