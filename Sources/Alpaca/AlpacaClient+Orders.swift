//
//  AlpacaClient+Orders.swift
//  
//
//  Created by Andrew Barba on 8/16/20.
//

import Foundation

public struct Order: Codable, Identifiable {
    public enum Class: String, Codable, CaseIterable {
        case simple = "simple"
        case bracket = "bracket"
        case oco = "oco"
        case oto = "oto"
    }

    public enum Side: String, Codable, CaseIterable {
        case buy = "buy"
        case sell = "sell"
    }

    public enum Status: String, Codable, CaseIterable {
        case new = "new"
        case partiallyFilled = "partially_filled"
        case filled = "filled"
        case doneForDay = "done_for_day"
        case canceled = "canceled"
        case expired = "expired"
        case replaced = "replaced"
        case pendingCancel = "pending_cancel"
        case pendingReplace = "pending_replace"
        case accepted = "accepted"
        case pendingNew = "pending_new"
        case acceptedForBidding = "accepted_for_bidding"
        case stopped = "stopped"
        case rejected = "rejected"
        case suspended = "suspended"
        case calculated = "calculated"

        // Used as query params
        public static let open = "open"
        public static let closed = "closed"
        public static let all = "all"
    }

    public enum OrderType: String, Codable, CaseIterable {
        case market = "market"
        case limit = "limit"
        case stop = "stop"
        case stopLimit = "stop_limit"
    }

    public enum TimeInForce: String, Codable, CaseIterable {
        case day = "day"
        case gtc = "gtc"
        case opg = "opg"
        case cls = "cls"
        case ioc = "ioc"
        case fok = "fok"
    }

    public let id: UUID
    public let clientOrderId: String
    public let createdAt: Date
    public let updatedAt: Date?
    public let submittedAt: Date?
    public let filledAt: Date?
    public let expiredAt: Date?
    public let canceledAt: Date?
    public let failedAt: Date?
    public let replacedAt: Date?
    public let replacedBy: UUID?
    public let replaces: UUID?
    public let assetId: UUID
    public let symbol: String
    public let assetClass: Asset.Class
    public let qty: NumericString<Double>
    public let filledQty: NumericString<Double>
    public let type: OrderType
    public let side: Side
    public let timeInForce: TimeInForce
    public let limitPrice: NumericString<Double>?
    public let stopPrice: NumericString<Double>?
    public let filledAvgPrice: NumericString<Double>?
    public let status: Status
    public let extendedHours: Bool
    public let legs: [Order]?
}

extension AlpacaClient {
    public func orders(status: String? = nil, limit: Int? = nil, after: Date? = nil, until: Date? = nil, direction: SortDirection? = nil, nested: Bool? = nil) -> ResponsePublisher<[Order]> {
        return get("orders", searchParams: [
            "status": status,
            "limit": limit.map(String.init),
            "after": after.map(Utils.iso8601DateFormatter.string),
            "until": until.map(Utils.iso8601DateFormatter.string),
            "direction": direction?.rawValue,
            "nested": nested.map(String.init)
        ])
    }

    public func order(id: UUID, nested: Bool? = nil) -> ResponsePublisher<Order> {
        return get("orders/\(id)", searchParams: ["nested": nested.map(String.init)])
    }

    public func order(id: String, nested: Bool? = nil) -> ResponsePublisher<Order> {
        return get("orders/\(id)", searchParams: ["nested": nested.map(String.init)])
    }

    public func createOrder(symbol: String, qty: Double, side: Order.Side, type: Order.OrderType, timeInForce: Order.TimeInForce, limitPrice: Double? = nil, stopPrice: Double? = nil, extendedHours: Bool = false, `class`: Order.Class? = nil, takeProfitLimitPrice: Double? = nil, stopLoss: (stopPrice: Double, limitPrice: Double?)? = nil) -> ResponsePublisher<Order> {
        return post("orders", body: [
            "symbol": symbol,
            "qty": qty,
            "side": side.rawValue,
            "type": type.rawValue,
            "time_in_force": timeInForce.rawValue,
            "limit_price": limitPrice,
            "stop_price": stopPrice,
            "extended_hours": extendedHours,
            "order_class": `class`?.rawValue,
            "take_profit": takeProfitLimitPrice.map { ["limit_price": $0] },
            "stop_loss": stopLoss.map { ["stop_price": $0.stopPrice, "limit_price": $0.limitPrice] }
        ])
    }

    public func cancelOrders() -> ResponsePublisher<[MultiResponse<Order>]> {
        return delete("orders")
    }

    public func cancelOrder(id: String) -> ResponsePublisher<Order> {
        return delete("orders/\(id)")
    }

    public func cancelOrder(id: UUID) -> ResponsePublisher<Order> {
        return delete("orders/\(id.uuidString)")
    }
}
