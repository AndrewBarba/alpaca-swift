//
//  File.swift
//  
//
//  Created by Mike Mello on 1/21/24.
//

import Foundation


public struct AlpacaTradingClient: AlpacaClientProtocol {
    let environment: Environment
    public let api: API
    public let timeoutInterval: TimeInterval
    
    init(environment: Environment, timeoutInterval: TimeInterval) {
        self.environment = environment
        switch environment {
        case .paper(let authType):
            self.api = .paper(authType: authType)
        case .live(let authType):
            self.api = .live(authType: authType)
        }
        self.timeoutInterval = timeoutInterval
    }
}
