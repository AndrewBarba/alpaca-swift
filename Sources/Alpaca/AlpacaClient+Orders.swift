//
//  AlpacaClient+Orders.swift
//  
//
//  Created by Andrew Barba on 8/16/20.
//

import Foundation

extension Models {
    public struct Order: Codable, Identifiable {
        public let id: UUID
    }
}

extension AlpacaClient {
    public func cancelOrders() -> ResponsePublisher<[Models.MultiResponse<Models.Order>]> {
        return delete("orders")
    }

    public func cancelOrder(id: String) -> ResponsePublisher<Models.Order> {
        return delete("orders/\(id)")
    }

    public func cancelOrder(id: UUID) -> ResponsePublisher<Models.Order> {
        return delete("orders/\(id.uuidString)")
    }
}
