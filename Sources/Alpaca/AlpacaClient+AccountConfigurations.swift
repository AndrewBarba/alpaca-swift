//
//  AlpacaClient+AccountConfiguration.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

extension Models {
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
}

extension AlpacaClient {
    public func accountConfigurations() -> ResponsePublisher<Models.AccountConfigurations> {
        return get("account/configurations")
    }

    public func saveAccountConfigurations(_ configurations: Models.AccountConfigurations) -> ResponsePublisher<Models.AccountConfigurations> {
        return patch("account/configurations", body: configurations)
    }

    public func saveAccountConfigurations(dtbpCheck: Models.AccountConfigurations.DayTradeBuyingPowerCheck? = nil, noShorting: Bool? = nil, suspendTrade: Bool? = nil, tradeConfirmEmail: Models.AccountConfigurations.TradeConfirmEmail? = nil) -> ResponsePublisher<Models.AccountConfigurations> {
        return patch("account/configurations", body: [
            "dtbp_check": dtbpCheck?.rawValue,
            "no_shorting": noShorting,
            "suspend_trade": suspendTrade,
            "trade_confirm_email": tradeConfirmEmail?.rawValue
        ])
    }
}
