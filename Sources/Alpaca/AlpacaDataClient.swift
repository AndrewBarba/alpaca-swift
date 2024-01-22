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

    init(authType: API.AuthType, timeoutInterval: TimeInterval) {
        self.api = .data(authType: authType)
        self.timeoutInterval = timeoutInterval
    }
}
