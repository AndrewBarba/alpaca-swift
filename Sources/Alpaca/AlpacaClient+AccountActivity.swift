//
//  File.swift
//  
//
//  Created by Mike Mello on 12/12/23.
//

import Foundation

public enum ActivityType: String, Codable {
    /**
     Order fills (both partial and full fills)
     */
    case fill = "FILL"
    /**
     Cash transactions (both CSD and CSW)
     */
    case trans = "TRANS"
    /**
     Miscellaneous or rarely used activity types (All types except those in TRANS, DIV, or FILL)
     */
    case misc = "MISC"
    /**
     ACATS IN/OUT (Cash)
     */
    case acatc = "ACATC"
    /**
     ACATS IN/OUT (Securities)
     */
    case acats = "ACATS"
    /**
     Crypto fee
     */
    case cfee = "CFEE"
    /**
     Cash deposit(+)
     */
    case csd = "CSD"
    /**
     Cash withdrawal(-)
     */
    case csw = "CSW"
    
    /**
    Not documented but presumably Cash Required? Seems to be for required deposits for opening a live account maybe?
     */
    case csr = "CSR"
    
    /**
     Dividends
     */
    case div = "DIV"
    /**
     Dividend (capital gain long term)
     */
    case divcgl = "DIVCGL"
    /**
     Dividend (capital gain short term)
     */
    case divcgs = "DIVCGS"
    /**
     Dividend fee
     */
    case divfee = "DIVFEE"
    /**
     Dividend adjusted (Foreign Tax Withheld)
     */
    case divft = "DIVFT"
    /**
     Dividend adjusted (NRA Withheld)
     */
    case divnra = "DIVNRA"
    /**
     Dividend return of capital
     */
    case divroc = "DIVROC"
    /**
     Dividend adjusted (Tefra Withheld)
     */
    case divtw = "DIVTW"
    /**
     Dividend (tax exempt)
     */
    case divtxes = "DIVTXEX"
    /**
     Fee denominated in USD
     */
    case fee = "FEE"
    /**
     Interest (credit/margin)
     */
    case int = "INT"
    /**
     Interest adjusted (NRA Withheld)
     */
    case intnra = "INTNRA"
    /**
     Interest adjusted (Tefra Withheld)
     */
    case inttw = "INTTW"
    /**
     Journal entry
     */
    case jnl = "JNL"
    /**
     Journal entry (cash)
     */
    case jnlc = "JNLC"
    /**
     Journal entry (stock)
     */
    case jnls = "JNLS"
    /**
     Merger/Acquisition
     */
    case ma = "MA"
    /**
     Name change
     */
    case nc = "NC"
    /**
     Option assignment
     */
    case opasn = "OPASN"
    /**
     Option expiration
     */
    case opexp = "OPEXP"
    /**
     Option exercise
     */
    case opxrc = "OPXRC"
    /**
     Pass Thru Charge
     */
    case ptc = "PTC"
    /**
     Pass Thru Rebate
     */
    case ptr = "PTR"
    /**
     Reorg CA
     */
    case reorg = "REORG"
    /**
     Symbol change
     */
    case sc = "SC"
    /**
     Stock spinoff
     */
    case sso = "SSO"
    /**
     Stock split
     */
    case ssp = "SSP"
}
public struct TradeActivity: Codable {
    public enum FillType: String, Codable {
        case fill
        case partialFill = "partial_fill"
    }
    
    public let id: String
    public let activityType: ActivityType
    public let cumQty: NumericString<Double>
    public let leavesQty: String
    public let price: NumericString<Double>
    public let qty: NumericString<Double>
    public let side: Order.Side
    public let symbol: String
    public let transactionTime: Date
    public let orderId: UUID
    public let type: FillType
    public let orderStatus: Order.Status
}

public struct NonTradeActivity: Codable {
    public let activityType: ActivityType
    public let id: String
    public let date: Date
    public let description: String
    public let netAmount: NumericString<Double>
    public let status: String?
}

public enum AccountActivity: Decodable {
    case trade(TradeActivity)
    case nonTrade(NonTradeActivity)
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case activityType
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let activityType = try container.decode(ActivityType.self, forKey: .activityType)
        switch activityType {
        case .fill:
            self = try .trade(TradeActivity(from: decoder))
        default:
            self = try .nonTrade(NonTradeActivity(from: decoder))
        }
    }
    
    public enum Category: String {
        case trade = "trade_activity"
        case nonTrade = "non_trade_activity"
    }
}


extension AlpacaClient {
    public func accountActivities(types: [ActivityType]? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities", searchParams: [
            "activity_types": types?.compactMap{ $0.rawValue }.joined(separator: ",")
        ])
    }

    public func accountActivities(type: ActivityType, date: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities/\(type.rawValue)", searchParams: [
            "date": Utils.iso8601DateOnlyFormatter.string(from: date),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken
        ])
    }
    
    public func accountActivities(category: AccountActivity.Category, date: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities", searchParams: [
            "date": Utils.iso8601DateOnlyFormatter.string(from: date),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken,
            "category": category.rawValue
        ])
    }
    
    public func accountActivities(type: ActivityType, after: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities/\(type.rawValue)", searchParams: [
            "after": Utils.iso8601DateOnlyFormatter.string(from: after),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken
        ])
    }
    
    public func accountActivities(type: ActivityType, until: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities/\(type.rawValue)", searchParams: [
            "until": Utils.iso8601DateOnlyFormatter.string(from: until),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken
        ])
    }
    
    public func accountActivities(type: ActivityType, after: Date, until: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities/\(type.rawValue)", searchParams: [
            "after": Utils.iso8601DateOnlyFormatter.string(from: after),
            "until": Utils.iso8601DateOnlyFormatter.string(from: until),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken
        ])
    }
    
    public func accountActivities(category: AccountActivity.Category, after: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities", searchParams: [
            "after": Utils.iso8601DateOnlyFormatter.string(from: after),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken,
            "category": category.rawValue
        ])
    }
    
    public func accountActivities(category: AccountActivity.Category, until: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities", searchParams: [
            "until": Utils.iso8601DateOnlyFormatter.string(from: until),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken,
            "category": category.rawValue
        ])
    }
    
    public func accountActivities(category: AccountActivity.Category, after: Date, until: Date, direction: SortDirection? = nil, pageSize: Int? = nil, pageToken: String? = nil) async throws -> [AccountActivity] {
        return try await get("account/activities", searchParams: [
            "after": Utils.iso8601DateOnlyFormatter.string(from: after),
            "until": Utils.iso8601DateOnlyFormatter.string(from: until),
            "direction": direction.map(\.rawValue),
            "page_size": pageSize.map(String.init),
            "page_token": pageToken,
            "category": category.rawValue
        ])
    }
}
