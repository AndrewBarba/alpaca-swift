//
//  AlpacaClient+Clock.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

extension AlpacaClient {

    public struct ClockResponse: Decodable {
        public let timestamp: Date
        public let isOpen: Bool
        public let nextOpen: Date
        public let nextClose: Date
    }

    public func clock() -> ResponsePublisher<ClockResponse> {
        return get("clock")
    }
}
