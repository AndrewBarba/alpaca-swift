//
//  AlpacaClient+Account.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct Account: Codable, Identifiable {
    public enum Status: String, Codable, CaseIterable {
        case onboarding = "ONBOARDING"
        case submissionFailed = "SUBMISSION_FAILED"
        case submitted = "SUBMITTED"
        case accountUpdated = "ACCOUNT_UPDATED"
        case approvalPending = "APPROVAL_PENDING"
        case active = "ACTIVE"
        case rejected = "REJECTED"
    }

    public let id: UUID
    public let accountNumber: String
    public let currency: String
    public let cash: NumericString<Double>
    public let status: Status
    public let patternDayTrader: Bool
    public let tradeSuspendedByUser: Bool
    public let tradingBlocked: Bool
    public let transfersBlocked: Bool
    public let accountBlocked: Bool
    public let createdAt: Date
    public let shortingEnabled: Bool
    public let longMarketValue: NumericString<Double>
    public let shortMarketValue: NumericString<Double>
    public let equity: NumericString<Double>
    public let lastEquity: NumericString<Double>
    public let multiplier: NumericString<Double>
    public let buyingPower: NumericString<Double>
    public let initialMargin: NumericString<Double>
    public let maintenanceMargin: NumericString<Double>
    public let sma: NumericString<Double>
    public let daytradeCount: Int
    public let lastMaintenanceMargin: NumericString<Double>
    public let daytradingBuyingPower: NumericString<Double>
    public let regtBuyingPower: NumericString<Double>
}

extension AlpacaClient {
    public func account() -> ResponsePublisher<Account> {
        return get("account")
    }
}
