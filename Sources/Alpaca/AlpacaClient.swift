import Foundation

public struct AlpacaClient: AlpacaClientProtocol {

    public let environment: Environment

    public let data: AlpacaDataClient

    public init(_ environment: Environment) {
        self.environment = environment
        self.data = AlpacaDataClient(key: environment.key, secret: environment.secret)
    }
}
