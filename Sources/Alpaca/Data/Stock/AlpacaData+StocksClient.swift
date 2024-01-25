//
//  File.swift
//  
//
//  Created by Mike Mello on 1/24/24.
//

import Foundation

extension AlpacaDataClient {
    public struct StocksClient: AlpacaClientProtocol {
        public var api: API
        
        public var timeoutInterval: TimeInterval
        
        init(authType: API.AuthType, timeoutInterval: TimeInterval) {
            self.api = .data(authType: authType)
            self.timeoutInterval = timeoutInterval
        }
    }
}
