//
//  AlpacaClient+Assets.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

extension Models {
    public struct Asset: Codable, Identifiable {
        public enum Class: String, Codable, CaseIterable {
            case usEquity = "us_equity"
        }

        public enum Exchange: String, Codable, CaseIterable {
            case amex = "AMEX"
            case arca = "ARCA"
            case bats = "BATS"
            case nyse = "NYSE"
            case nasdaq = "NASDAQ"
            case nyseArca = "NYSEARCA"
            case otc = "OTC"
        }

        public enum Status: String, Codable, CaseIterable {
            case active = "active"
            case inactive = "inactive"
        }

        public let id: UUID
        public let `class`: Class
        public let exchange: Exchange
        public let symbol: String
        public let name: String
        public let status: Status
        public let tradable: Bool
        public let marginable: Bool
        public let shortable: Bool
        public let easyToBorrow: Bool
    }
}

extension AlpacaClient {
    public func assets(status: Models.Asset.Status? = nil, assetClass: Models.Asset.Class? = nil) -> ResponsePublisher<[Models.Asset]> {
        return get("assets", searchParams: ["status": status?.rawValue, "asset_class": assetClass?.rawValue])
    }

    public func asset(id: String) -> ResponsePublisher<Models.Asset> {
        return get("assets/\(id)")
    }

    public func asset(id: UUID) -> ResponsePublisher<Models.Asset> {
        return get("assets/\(id.uuidString)")
    }

    public func asset(symbol: String) -> ResponsePublisher<Models.Asset> {
        return get("assets/\(symbol)")
    }
}
