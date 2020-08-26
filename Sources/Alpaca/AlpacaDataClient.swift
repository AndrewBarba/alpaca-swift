//
//  File.swift
//  
//
//  Created by Andrew Barba on 8/25/20.
//

import AsyncHTTPClient
import Foundation

public struct AlpacaDataClient: AlpacaClientProtocol {

    public let environment: Environment

    internal init(key: String, secret: String) {
        self.environment = .data(key: key, secret: secret)
    }
}
