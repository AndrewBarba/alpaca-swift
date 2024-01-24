//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public struct AlpacaDataClient: AlpacaClientProtocol {    
    public let api: API
    public let timeoutInterval: TimeInterval
    
    public let screener: AlpacaScreenerClient

    init(authType: API.AuthType, timeoutInterval: TimeInterval) {
        self.api = .data(authType: authType)
        self.timeoutInterval = timeoutInterval
        
        self.screener = AlpacaScreenerClient(authType: authType, timeoutInterval: timeoutInterval)
    }
}
