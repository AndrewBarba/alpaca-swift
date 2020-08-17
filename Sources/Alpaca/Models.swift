//
//  Models.swift
//  
//
//  Created by Andrew Barba on 8/15/20.
//

import Foundation

public enum Models {}

extension Models {
    public struct MultiResponse<T>: Codable where T: Codable {
        public let status: Int
        public let body: T
    }

    public enum SortDirection: String, Codable, CaseIterable {
        case asc = "asc"
        case desc = "desc"
    }
}
