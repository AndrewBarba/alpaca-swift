import Foundation

public struct AlpacaClient: AlpacaClientProtocol {
    
    public let environment: Environment
    
    public let data: AlpacaDataClient
    
    public let timeoutInterval: TimeInterval
    
    public init(_ environment: Environment, timeoutInterval: TimeInterval = 10, dataTimeoutInterval: TimeInterval = 10) {
        self.environment = environment
        self.timeoutInterval = timeoutInterval
        self.data = {
            switch environment.authType {
                case .basic(let key, let secret):
                    return AlpacaDataClient(key: key, secret: secret, timeoutInterval: dataTimeoutInterval)
                case .oauth(let accessToken):
                    return AlpacaDataClient(accessToken: accessToken, timeoutInterval: timeoutInterval)
            }
        }()
    }
}
