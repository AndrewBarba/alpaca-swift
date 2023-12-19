//
//  File.swift
//  
//
//  Created by Mike Mello on 12/18/23.
//

import Foundation

public struct AlpacaScreenerClient: AlpacaClientProtocol {

    public let environment: Environment
    
    public let timeoutInterval: TimeInterval

    internal init(key: String, secret: String, timeoutInterval: TimeInterval) {
        self.environment = .screener(key: key, secret: secret)
        self.timeoutInterval = timeoutInterval
    }
    
    internal init(accessToken: String, timeoutInterval: TimeInterval) {
        self.environment = .screener(accessToken: accessToken)
        self.timeoutInterval = timeoutInterval
    }
}
