//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public enum Environment {
    case live(authType: API.AuthType)
    case paper(authType: API.AuthType)
    
    func authType() -> API.AuthType {
        switch self {
        case .live(let authType):
            return authType
        case .paper(let authType):
            return authType
        }
    }
}

public enum API {
    public enum AuthType {
        case basic(key: String, secret: String)
        case oauth(accessToken: String)
        
        func authorize(request: inout URLRequest) {
            switch self {
            case .basic(let key, let secret):
                request.setValue(key, forHTTPHeaderField: "APCA-API-KEY-ID")
                request.setValue(secret, forHTTPHeaderField: "APCA-API-SECRET-KEY")
            case .oauth(let accessToken):
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    case paper(authType: AuthType)
    case live(authType: AuthType)
    case data(authType: AuthType)
    
    var domain: String {
        switch self {
        case .paper:
            return "paper-api.alpaca.markets"
        case .live:
            return "api.alpaca.markets"
        case .data:
            return "data.alpaca.markets"
        }
    }
}
