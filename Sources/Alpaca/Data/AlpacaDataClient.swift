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
    
    public let stocks: StocksClient
    public let screener: ScreenerClient
    public let news: NewsClient
    public let corporateActions: CorporateActionsClient

    init(authType: API.AuthType, timeoutInterval: TimeInterval) {
        self.api = .data(authType: authType)
        self.timeoutInterval = timeoutInterval
        
        self.stocks = StocksClient(authType: authType, timeoutInterval: timeoutInterval)
        self.screener = ScreenerClient(authType: authType, timeoutInterval: timeoutInterval)
        self.news = NewsClient(authType: authType, timeoutInterval: timeoutInterval)
        self.corporateActions = CorporateActionsClient(authType: authType, timeoutInterval: timeoutInterval)
    }
}
