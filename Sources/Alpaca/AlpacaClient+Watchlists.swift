//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/17/20.
//

import Foundation

extension Models {
    public struct Watchlist: Codable, Identifiable {
        public let id: UUID
        public let accountId: UUID
        public let name: String
        public let createdAt: Date
        public let updatedAt: Date
        public let assets: [Models.Asset]?
    }
}

extension AlpacaClient {
    public func watchlists() -> ResponsePublisher<[Models.Watchlist]> {
        return get("watchlists")
    }

    public func createWatchlist(name: String, symbols: [String]) -> ResponsePublisher<Models.Watchlist> {
        return post("watchlists", body: ["name": name, "symbols": symbols])
    }

    public func watchlist(id: String) -> ResponsePublisher<Models.Watchlist> {
        return get("watchlists/\(id)")
    }

    public func watchlist(id: UUID) -> ResponsePublisher<Models.Watchlist> {
        return get("watchlists/\(id.uuidString)")
    }

    public func updateWatchlist(id: String, name: String? = nil, symbols: [String]? = nil) -> ResponsePublisher<Models.Watchlist> {
        return put("watchlists/\(id)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: UUID, name: String? = nil, symbols: [String]? = nil) -> ResponsePublisher<Models.Watchlist> {
        return put("watchlists/\(id.uuidString)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: String, add symbol: String) -> ResponsePublisher<Models.Watchlist> {
        return post("watchlists/\(id)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: UUID, add symbol: String) -> ResponsePublisher<Models.Watchlist> {
        return post("watchlists/\(id.uuidString)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: String, remove symbol: String) -> ResponsePublisher<Models.Watchlist> {
        return delete("watchlists/\(id)/\(symbol)")
    }

    public func updateWatchlist(id: UUID, remove symbol: String) -> ResponsePublisher<Models.Watchlist> {
        return delete("watchlists/\(id.uuidString)/\(symbol)")
    }

    public func deleteWatchlist(id: String) -> ResponsePublisher<Models.EmptyResponse> {
        return delete("watchlists/\(id)")
    }

    public func deleteWatchlist(id: UUID) -> ResponsePublisher<Models.EmptyResponse> {
        return delete("watchlists/\(id.uuidString)")
    }
}
