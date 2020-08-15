//
//  AlpacaClient+Assets.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

extension Models {
    public struct Asset: Decodable {
        public enum Exchange: String, Decodable, CaseIterable {
            case amex = "AMEX"
            case arca = "ARCA"
            case bats = "BATS"
            case nyse = "NYSE"
            case nasdaq = "NASDAQ"
            case nyseArca = "NYSEARCA"
        }

        public enum Status: String, Decodable, CaseIterable {
            case active = "active"
            case inactive = "inactive"
        }

        public let id: UUID
        public let `class`: String
        public let exchange: Exchange
        public let symbol: String
        public let status: Status
        public let tradable: Bool
        public let marginable: Bool
        public let shortable: Bool
        public let easyToBorrow: Bool
    }
}

extension AlpacaClient {
    public func assets(status: Models.Asset.Status? = nil, `class`: String? = nil) -> ResponsePublisher<[Models.Asset]> {
        return get("assets", searchParams: ["status": status?.rawValue, "class": `class`])
    }

    public func asset(id: String) -> ResponsePublisher<Models.Asset> {
        return get("assets/\(id)")
    }
}
