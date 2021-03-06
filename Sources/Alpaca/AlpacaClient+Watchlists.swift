//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/17/20.
//

import Foundation

public struct Watchlist: Codable, Identifiable {
    public let id: UUID
    public let accountId: UUID
    public let name: String
    public let createdAt: Date
    public let updatedAt: Date
    public let assets: [Asset]?
}

extension AlpacaClient {
    public func watchlists() -> ResponsePublisher<[Watchlist]> {
        return get("watchlists")
    }

    public func createWatchlist(name: String, symbols: [String]) -> ResponsePublisher<Watchlist> {
        return post("watchlists", body: ["name": name, "symbols": symbols])
    }

    public func watchlist(id: String) -> ResponsePublisher<Watchlist> {
        return get("watchlists/\(id)")
    }

    public func watchlist(id: UUID) -> ResponsePublisher<Watchlist> {
        return get("watchlists/\(id.uuidString)")
    }

    public func updateWatchlist(id: String, name: String? = nil, symbols: [String]? = nil) -> ResponsePublisher<Watchlist> {
        return put("watchlists/\(id)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: UUID, name: String? = nil, symbols: [String]? = nil) -> ResponsePublisher<Watchlist> {
        return put("watchlists/\(id.uuidString)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: String, add symbol: String) -> ResponsePublisher<Watchlist> {
        return post("watchlists/\(id)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: UUID, add symbol: String) -> ResponsePublisher<Watchlist> {
        return post("watchlists/\(id.uuidString)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: String, remove symbol: String) -> ResponsePublisher<Watchlist> {
        return delete("watchlists/\(id)/\(symbol)")
    }

    public func updateWatchlist(id: UUID, remove symbol: String) -> ResponsePublisher<Watchlist> {
        return delete("watchlists/\(id.uuidString)/\(symbol)")
    }

    public func deleteWatchlist(id: String) -> EmptyResponsePublisher {
        return delete("watchlists/\(id)")
    }

    public func deleteWatchlist(id: UUID) -> EmptyResponsePublisher {
        return delete("watchlists/\(id.uuidString)")
    }
}
