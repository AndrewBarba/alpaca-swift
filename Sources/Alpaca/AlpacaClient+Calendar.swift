//
//  AlpacaClient+Calendar.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

extension AlpacaClient {

    public struct CalendarResponse: Decodable {
        public let date: Date
        public let open: String
        public let close: String
    }

    public func calendar(start: String? = nil, end: String? = nil) -> ResponsePublisher<[CalendarResponse]> {
        return get("calendar", searchParams: ["start": start, "end": end])
    }

    public func calendar(start: Date? = nil, end: Date? = nil) -> ResponsePublisher<[CalendarResponse]> {
        return get("calendar", searchParams: [
            "start": start != nil ? Utils.iso8601DateOnlyFormatter.string(from: start!) : nil,
            "end": end != nil ? Utils.iso8601DateOnlyFormatter.string(from: end!) : nil
        ])
    }
}
