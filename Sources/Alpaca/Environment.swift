//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public struct Environment {
    public enum AuthType {
        case basic(key: String, secret: String)
        case oauth(accessToken: String)
    }
    public let api: String
    public let authType: AuthType

    internal static func data(key: String, secret: String) -> Self {
        Environment(api: "https://data.alpaca.markets/v2", authType: .basic(key: key, secret: secret))
    }
    
    internal static func data(accessToken: String) -> Self {
        Environment(api: "https://data.alpaca.markets/v2", authType: .oauth(accessToken: accessToken))
    }

    public static func live(key: String, secret: String) -> Self {
        Environment(api: "https://api.alpaca.markets/v2", authType: .basic(key: key, secret: secret))
    }
    
    public static func live(accessToken: String) -> Self {
        Environment(api: "https://api.alpaca.markets/v2", authType: .oauth(accessToken: accessToken))
    }

    public static func paper(key: String, secret: String) -> Self {
        Environment(api: "https://paper-api.alpaca.markets/v2", authType: .basic(key: key, secret: secret))
    }
    
    public static func paper(accessToken: String) -> Self {
        Environment(api: "https://paper-api.alpaca.markets/v2", authType: .oauth(accessToken: accessToken))
    }
}
