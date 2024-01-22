//
//  File.swift
//  
//
//  Created by Mike Mello on 1/21/24.
//

import Foundation

public struct AlpacaAPI {
    
    public var trading: AlpacaTradingClient
    public var data: AlpacaDataClient
    
    public init(_ environment: Environment, timeoutInterval: TimeInterval = 10) {
        self.trading = AlpacaTradingClient(environment: environment, timeoutInterval: timeoutInterval)
        self.data = AlpacaDataClient(authType: environment.authType(), timeoutInterval: timeoutInterval)
    }
}
