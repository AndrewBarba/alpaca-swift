//
//  AlpacaClient+Calendar.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public struct Calendar: Codable {
    public let date: Date
    public let open: String
    public let close: String
}

extension AlpacaClient {
    public func calendar(start: String? = nil, end: String? = nil) -> ResponsePublisher<[Calendar]> {
        return get("calendar", searchParams: ["start": start, "end": end])
    }

    public func calendar(start: Date? = nil, end: Date? = nil) -> ResponsePublisher<[Calendar]> {
        return calendar(
            start: start.map(Utils.iso8601DateOnlyFormatter.string),
            end: end.map(Utils.iso8601DateOnlyFormatter.string)
        )
    }
}
