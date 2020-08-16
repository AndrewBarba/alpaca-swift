//
//  Models.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public enum Models {}

extension Models {
    public struct MultiResponse<T>: Codable, Identifiable where T: Codable {
        public let id: UUID
        public let status: Int
        public let body: T
    }
}
