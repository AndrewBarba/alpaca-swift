//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public struct Environment {
    public let api: String
    public let key: String
    public let secret: String

    internal static func data(key: String, secret: String) -> Self {
        Environment(api: "https://data.alpaca.markets/v1", key: key, secret: secret)
    }

    public static func live(key: String, secret: String) -> Self {
        Environment(api: "https://api.alpaca.markets/v2", key: key, secret: secret)
    }

    public static func paper(key: String, secret: String) -> Self {
        Environment(api: "https://paper-api.alpaca.markets/v2", key: key, secret: secret)
    }
}
