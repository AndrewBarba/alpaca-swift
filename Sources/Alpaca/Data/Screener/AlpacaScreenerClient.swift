//
//  File.swift
//  
//
//  Created by Mike Mello on 1/23/24.
//

import Foundation

public struct AlpacaScreenerClient: AlpacaClientProtocol {
    public var api: API
    
    public var timeoutInterval: TimeInterval
    
    init(authType: API.AuthType, timeoutInterval: TimeInterval) {
        self.api = .data(authType: authType)
        self.timeoutInterval = timeoutInterval
    }
}
