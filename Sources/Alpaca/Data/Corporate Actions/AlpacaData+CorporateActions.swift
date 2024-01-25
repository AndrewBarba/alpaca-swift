//
//  File.swift
//  
//
//  Created by Mike Mello on 1/25/24.
//

import Foundation

extension AlpacaDataClient {
    public struct CorporateActionsClient: AlpacaClientProtocol {
        public var api: API
        
        public var timeoutInterval: TimeInterval
        
        init(authType: API.AuthType, timeoutInterval: TimeInterval) {
            self.api = .data(authType: authType)
            self.timeoutInterval = timeoutInterval
        }
    }
}
