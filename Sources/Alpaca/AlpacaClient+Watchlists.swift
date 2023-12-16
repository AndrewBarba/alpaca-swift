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
    public let assets: [Asset]
    
    public init(id: UUID, accountId: UUID, name: String, createdAt: Date, updatedAt: Date, assets: [Asset]) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.assets = assets
    }
}

extension AlpacaClient {
    public func watchlists() async throws -> [Watchlist] {
        return try await get("watchlists")
    }

    public func createWatchlist(name: String, symbols: [String]) async throws -> Watchlist {
        return try await post("watchlists", body: ["name": name, "symbols": symbols])
    }

    public func watchlist(id: String) async throws -> Watchlist {
        return try await get("watchlists/\(id)")
    }

    public func watchlist(id: UUID) async throws -> Watchlist {
        return try await get("watchlists/\(id.uuidString)")
    }

    public func updateWatchlist(id: String, name: String? = nil, symbols: [String]? = nil) async throws -> Watchlist {
        return try await put("watchlists/\(id)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: UUID, name: String? = nil, symbols: [String]? = nil) async throws -> Watchlist {
        return try await put("watchlists/\(id.uuidString)", body: ["name": name, "symbols": symbols])
    }

    public func updateWatchlist(id: String, add symbol: String) async throws -> Watchlist {
        return try await post("watchlists/\(id)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: UUID, add symbol: String) async throws -> Watchlist {
        return try await post("watchlists/\(id.uuidString)", body: ["symbol": symbol])
    }

    public func updateWatchlist(id: String, remove symbol: String) async throws -> Watchlist {
        return try await delete("watchlists/\(id)/\(symbol)")
    }

    public func updateWatchlist(id: UUID, remove symbol: String) async throws -> Watchlist {
        return try await delete("watchlists/\(id.uuidString)/\(symbol)")
    }

    public func deleteWatchlist(id: String) async throws -> EmptyResponse {
        return try await delete("watchlists/\(id)")
    }

    public func deleteWatchlist(id: UUID) async throws -> EmptyResponse {
        return try await delete("watchlists/\(id.uuidString)")
    }
}
