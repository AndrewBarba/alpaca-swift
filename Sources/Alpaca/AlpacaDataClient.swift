//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import Foundation

public struct AlpacaDataClient: AlpacaClientProtocol {

    public let environment: Environment
    
    public let timeoutInterval: TimeInterval

    internal init(key: String, secret: String, timeoutInterval: TimeInterval) {
        self.environment = .data(key: key, secret: secret)
        self.timeoutInterval = timeoutInterval
    }
}
