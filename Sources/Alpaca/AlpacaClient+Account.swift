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
    
    public enum CryptoStatus: String, Codable, CaseIterable {
        case paperOnly = "PAPER_ONLY"
        case submitted = "SUBMITTED"
        case active = "ACTIVE"
    }

    public let id: UUID
    public let accountNumber: String
    public let currency: String
    public let cash: NumericString<Double>
    public let status: Status
    public let cryptoStatus: CryptoStatus
    public let accruedFees: NumericString<Double>
    public let pendingTransferIn: NumericString<Double>
    public let pendingTransferOut: NumericString<Double>?
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
    public let nonMarginableBuyingPower: NumericString<Double>
    public let initialMargin: NumericString<Double>
    public let maintenanceMargin: NumericString<Double>
    public let sma: NumericString<Double>
    public let daytradeCount: Int
    public let lastMaintenanceMargin: NumericString<Double>
    public let daytradingBuyingPower: NumericString<Double>
    public let regtBuyingPower: NumericString<Double>
    
    public init(id: UUID, accountNumber: String, currency: String, cash: NumericString<Double>, status: Status, cryptoStatus: CryptoStatus, accruedFees: NumericString<Double>, pendingTransferIn: NumericString<Double>, pendingTransferOut: NumericString<Double>?, patternDayTrader: Bool, tradeSuspendedByUser: Bool, tradingBlocked: Bool, transfersBlocked: Bool, accountBlocked: Bool, createdAt: Date, shortingEnabled: Bool, longMarketValue: NumericString<Double>, shortMarketValue: NumericString<Double>, equity: NumericString<Double>, lastEquity: NumericString<Double>, multiplier: NumericString<Double>, buyingPower: NumericString<Double>, nonMarginableBuyingPower: NumericString<Double>, initialMargin: NumericString<Double>, maintenanceMargin: NumericString<Double>, sma: NumericString<Double>, daytradeCount: Int, lastMaintenanceMargin: NumericString<Double>, daytradingBuyingPower: NumericString<Double>, regtBuyingPower: NumericString<Double>) {
        self.id = id
        self.accountNumber = accountNumber
        self.currency = currency
        self.cash = cash
        self.status = status
        self.cryptoStatus = cryptoStatus
        self.accruedFees = accruedFees
        self.pendingTransferIn = pendingTransferIn
        self.pendingTransferOut = pendingTransferOut
        self.patternDayTrader = patternDayTrader
        self.tradeSuspendedByUser = tradeSuspendedByUser
        self.tradingBlocked = tradingBlocked
        self.transfersBlocked = transfersBlocked
        self.accountBlocked = accountBlocked
        self.createdAt = createdAt
        self.shortingEnabled = shortingEnabled
        self.longMarketValue = longMarketValue
        self.shortMarketValue = shortMarketValue
        self.equity = equity
        self.lastEquity = lastEquity
        self.multiplier = multiplier
        self.buyingPower = buyingPower
        self.nonMarginableBuyingPower = nonMarginableBuyingPower
        self.initialMargin = initialMargin
        self.maintenanceMargin = maintenanceMargin
        self.sma = sma
        self.daytradeCount = daytradeCount
        self.lastMaintenanceMargin = lastMaintenanceMargin
        self.daytradingBuyingPower = daytradingBuyingPower
        self.regtBuyingPower = regtBuyingPower
    }
}

extension AlpacaClient {
    public func account() async throws -> Account {
        return try await get("account")
    }
}
