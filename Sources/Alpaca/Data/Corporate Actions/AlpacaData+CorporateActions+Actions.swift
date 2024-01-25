//
//  File.swift
//  
//
//  Created by Mike Mello on 1/25/24.
//

import Foundation

public struct CorporateActions: Codable {
    public enum Types: String, Codable {
        case reverseSplit       = "reverse_split"
        case forwardSplit       = "forward_split"
        case unitSplit          = "unit_split"
        case cashDividend       = "cash_dividend"
        case stockDividend      = "stock_dividend"
        case spinOff            = "spin_off"
        case cashMerger         = "cash_merger"
        case stockMerger        = "stock_merger"
        case stockAndCashMerger  = "stock_and_cash_merger"
        case redemption         = "redemption"
        case nameChange         = "name_change"
        case worthlessRemoval   = "worthless_removal"
    }
    
    public struct ReverseSplit: Codable {
        public let symbol: String
        public let newRate: Double
        public let oldRate: Double
        public let processDate: Date
        public let exDate: Date
        public let recordDate: Date?
        public let payableDate: Date?
    }
    
    public struct ForwardSplit: Codable {
        public let symbol: String
        public let newRate: Double
        public let oldRate: Double
        public let processDate: Date
        public let exDate: Date
        public let recordDate: Date?
        public let payableDate: Date?
        public let dueBillRedemptionDate: Date?
    }
    
    public struct UnitSplit: Codable {
        public let oldSymbol: String
        public let oldRate: String
        public let newSymbol: String
        public let newRate: String
        public let alternateSymbol: String
        public let alternateRate: String
        public let processDate: Date
        public let effectiveDate: Date
        public let payableDate: Date?
    }
    
    public struct StockDividend: Codable {
        public let symbol: String
        public let rate: Double
        public let processDate: Date
        public let exDate: Date
        public let recordDate: Date?
        public let payableDate: Date?
    }
    
    public struct CashDividend: Codable {
        public let symbol: String
        public let rate: Double
        public let special: Bool
        public let foreign: Bool
        public let processDate: Date
        public let exDate: Date
        public let recordDate: Date?
        public let payableDate: Date?
        public let dueBillOnDate: Date?
        public let dueBillOffDate: Date?
    }
    
    public struct SpinOff: Codable {
        public let sourceSymbol: String
        public let sourceRate: Double
        public let newSymbol: String
        public let newRate: Double
        public let processDate: Date
        public let exDate: Date
        public let recordDate: Date?
        public let payableDate: Date?
        public let dueBillRedemptionDate: Date?
    }
    
    public struct CashMerger: Codable {
        public let acquirerSymbol: String?
        public let acquireeSymbol: String
        public let rate: Double
        public let processDate: Date
        public let effectiveDate: Date
        public let payableDate: Date?
    }
    
    public struct StockMerger: Codable {
        public let acquirerSymbol: String
        public let acquirerRate: Double
        public let acquireeSymbol: String
        public let acquireeRate: Double
        public let processDate: Date
        public let effectiveDate: Date
        public let payableDate: Date?
    }
    
    public struct StockAndCashMerger: Codable {
        public let acquirerSymbol: String
        public let acquirerRate: Double
        public let acquireeSymbol: String
        public let acquireeRate: Double
        public let cashRate: Double
        public let processDate: Date
        public let effectiveDate: Date
        public let payableDate: Date?
    }
    
    public struct Redemption: Codable {
        public let symbol: String
        public let rate: Double
        public let processDate: Date
        public let payableDate: Date?
    }
    
    public struct NameChange: Codable {
        public let oldSymbol: String
        public let newSymbol: String
        public let processDate: Date
    }
    
    public struct WorthlessRemoval: Codable {
        public let symbol: String
        public let processDate: Date
    }
    
    public let reverseSplits: [ReverseSplit]?
    public let forwardSplits: [ForwardSplit]?
    public let unitSplits: [UnitSplit]?
    public let stockDividends: [StockDividend]?
    public let cashDividends: [CashDividend]?
    public let spinOffs: [SpinOff]?
    public let cashMergers: [CashMerger]?
    public let stockMergers: [StockMerger]?
    public let stockAndCashMergers: [StockAndCashMerger]?
    public let redemptions: [Redemption]?
    public let nameChanges: [NameChange]?
    public let worthlessRemovals: [WorthlessRemoval]?
}

struct CorporateActionsResponse: Codable {
    let corporateActions: CorporateActions
    let nextPageToken: String?
}

extension AlpacaDataClient.CorporateActionsClient {
     
    func actions(
        symbols: [String],
        types: [CorporateActions.Types]? = nil,
        start: Date? = nil,
        end: Date? = nil,
        limit: Int64? = nil,
        sort: SortDirection? = nil,
        pageToken: String? = nil
    ) async throws -> CorporateActionsResponse {
        return try await get("/v1beta1/corporate-actions", searchParams: [
            "symbols": symbols.joined(separator: ","),
            "types": types?.map(\.rawValue).joined(separator: ","),
            "start": start.map(Utils.iso8601DateOnlyFormatter.string),
            "end": end.map(Utils.iso8601DateOnlyFormatter.string),
            "limit": limit.map(String.init),
            "sort": sort.map(\.rawValue),
            "page_token": pageToken
        ])
    }
}
