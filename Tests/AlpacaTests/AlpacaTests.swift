import XCTest
@testable import Alpaca

enum Environment: String {
    case alpacaApiKey = "ALPACA_API_KEY"
    case alpacaApiSecret = "ALPACA_API_SECRET"

    var value: String {
        return ProcessInfo.processInfo.environment[rawValue] ?? ""
    }
}

final class AlpacaTests: XCTestCase {

    let client = AlpacaClient(.paper(key: Environment.alpacaApiKey.value, secret: Environment.alpacaApiSecret.value))

    func testClientAPI() {
        XCTAssertEqual(client.environment.api, "https://paper-api.alpaca.markets/v2")
    }

    func testAccountRequest() async throws {
        _ = try await client.account()
    }

    func testAccountConfigurationsRequest() async throws {
        _ = try await client.accountConfigurations()
    }

    func testAccountConfigurationsUpdateRequest() async throws {
        _ = try await client.saveAccountConfigurations(dtbpCheck: .exit)
    }

    func testAssetsRequest() async throws {
        _ = try await client.assets(status: .inactive)
    }

    func testAssetSymbolRequest() async throws {
        _ = try await client.asset(symbol: "AAPL")
    }

    func testClockRequest() async throws {
        _ = try await client.clock()
    }

    func testCalendarRequest() async throws {
        _ = try await client.calendar(start: "2020-01-01", end: "2020-01-07")
    }

    func testPortfolioHistoryRequest() async throws {
        _ = try await client.portfolioHistory()
    }

    func testPositionsRequest() async throws {
        _ = try await client.positions()
    }

    func testClosePositionsRequest() async throws {
        _ = try await client.closePositions()
    }

    func testOrdersRequest() async throws {
        _ = try await client.orders()
    }

    func testCreateOrderRequest() async throws {
        _ = try await client.createOrder(symbol: "AAPL", qty: 2, side: .buy, type: .market, timeInForce: .day)
    }

    func testCancelOrdersRequest() async throws {
        _ = try await client.cancelOrders()
    }

    func testWatchlistsRequest() async throws {
        _ = try await client.watchlists()
    }

    func testCreateAndDeleteWatchlistRequest() async throws {
        _ = try await client.createWatchlist(name: "[Swift] \(UUID().uuidString)", symbols: ["AAPL"])
    }

    func testDataBarsRequest() async throws {
        _ = _ = try await client.data.bars(.oneDay, symbol: "AAPL", limit: 1)
    }

    func testDataBarsMultiRequest() async throws {
        _ = _ = try await client.data.bars(.oneDay, symbols: ["AAPL", "FSLY"], limit: 1)
    }

    static var allTests = [
        ("testAccountRequest", testAssetsRequest),
        ("testAccountConfigurationsRequest", testAccountConfigurationsRequest),
        ("testAccountConfigurationsUpdateRequest", testAccountConfigurationsUpdateRequest),
        ("testAssetsRequest", testAssetsRequest),
        ("testAssetSymbolRequest", testAssetSymbolRequest),
        ("testClientAPI", testClientAPI),
        ("testCalendarRequest", testCalendarRequest),
        ("testClockRequest", testClockRequest),
        ("testPortfolioHistoryRequest", testPortfolioHistoryRequest),
        ("testPositionsRequest", testPositionsRequest),
        ("testClosePositionsRequest", testClosePositionsRequest),
        ("testOrdersRequest", testOrdersRequest),
        ("testCreateOrderRequest", testCreateOrderRequest),
        ("testCancelOrdersRequest", testCancelOrdersRequest),
        ("testWatchlistsRequest", testWatchlistsRequest),
        ("testCreateAndDeleteWatchlistRequest", testCreateAndDeleteWatchlistRequest),
        ("testDataBarsRequest", testDataBarsRequest),
        ("testDataBarsMultiRequest", testDataBarsMultiRequest)
    ]
}
