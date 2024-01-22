import XCTest
@testable import Alpaca

enum Environment: String {
    case alpacaApiKey = "ALPACA-KEY"
    case alpacaApiSecret = "ALPACA-SECRET"

    var value: String {
        return ProcessInfo.processInfo.environment[rawValue] ?? ""
    }
}

final class AlpacaTests: XCTestCase {

    let client = AlpacaAPI(environment: .paper(authType: .basic(key: Environment.alpacaApiKey.rawValue, secret: Environment.alpacaApiSecret.rawValue)))

    func testClientAPI() {
        XCTAssertEqual(client.trading.api.domain, "paper-api.alpaca.markets")
    }

    func testAccountRequest() async throws {
        _ = try await client.trading.account()
    }

    func testAccountConfigurationsRequest() async throws {
        _ = try await client.trading.accountConfigurations()
    }

    func testAccountConfigurationsUpdateRequest() async throws {
        _ = try await client.trading.saveAccountConfigurations(dtbpCheck: .exit)
    }
    
    func testAccountActivities() async throws {
        _ = try await client.trading.accountActivities()
    }
    
    func testAccountActivitiesType() async throws {
        _ = try await client.trading.accountActivities(type: .fill, date: Date(timeIntervalSince1970: 170000000))
    }
    func testAccountActivitiesCategory() async throws {
        _ = try await client.trading.accountActivities(category: .trade, date: Date(timeIntervalSince1970: 170000000))
    }
    func testAccountActivitiesTypeAfter() async throws {
        _ = try await client.trading.accountActivities(type: .fill, after: Date(timeIntervalSince1970: 170000000))
    }
    func testAccountActivitiesTypeUntil() async throws {
        _ = try await client.trading.accountActivities(type: .fill, until: .now)
    }
    func testAccountActivitiesTypeAfterUntil() async throws {
        _ = try await client.trading.accountActivities(type: .fill, after: Date(timeIntervalSince1970: 170000000), until: .now)
    }
    func testAccountActivitiesCateogryAfter() async throws {
        _ = try await client.trading.accountActivities(category: .trade, after: Date(timeIntervalSince1970: 170000000))
    }
    func testAccountActivitiesCategoryUntil() async throws {
        _ = try await client.trading.accountActivities(category: .trade, until: .now)
    }
    func testAccountActivitiesCategoryAfterUntil() async throws {
        _ = try await client.trading.accountActivities(category: .nonTrade, after: Date(timeIntervalSince1970: 170000000), until: .now)
    }

    func testAssetsRequest() async throws {
        _ = try await client.trading.assets(status: .inactive)
    }

    func testAssetSymbolRequest() async throws {
        _ = try await client.trading.asset(symbol: "AAPL")
    }

    func testClockRequest() async throws {
        _ = try await client.trading.clock()
    }

    func testCalendarRequest() async throws {
        _ = try await client.trading.calendar(start: "2020-01-01", end: "2020-01-07")
    }

    func testPortfolioHistoryRequest() async throws {
        _ = try await client.trading.portfolioHistory()
    }
    
    func testPortfolioHistoryRequest_BeforeAccountCreation() async throws {
        let history = try await client.trading.portfolioHistory(period: "1800D",timeframe: .oneDay)
        print(history.values[0].profitLossPct)
    }

    func testPositionsRequest() async throws {
        _ = try await client.trading.positions()
    }

    func testClosePositionsRequest() async throws {
        _ = try await client.trading.closePositions()
    }

    func testOrdersRequest() async throws {
        _ = try await client.trading.orders()
    }

    func testCreateOrderRequest() async throws {
        _ = try await client.trading.createOrder(symbol: "AAPL", qty: 2, side: .buy, type: .market, timeInForce: .day)
    }

    func testCancelOrdersRequest() async throws {
        _ = try await client.trading.cancelOrders()
    }

    func testWatchlistsRequest() async throws {
        _ = try await client.trading.watchlists()
    }

    func testCreateAndDeleteWatchlistRequest() async throws {
        _ = try await client.trading.createWatchlist(name: "[Swift] \(UUID().uuidString)", symbols: ["AAPL"])
    }

    func testDataBarsRequest() async throws {
        _ = _ = try await client.data.bars(.oneDay, symbol: "AAPL", limit: 1)
    }
    
    func testBarsMultiPage() async throws {
        _ = _ = try await client.data.bars(.oneDay, symbols: ["AAPL", "TSLA", "SPY", "QQQ", "AMD", "GEVO", "AMZN", "SQQQ", "AVGO", "SNAP"], start: Calendar.current.date(byAdding: .month, value: -6, to: .now))
    }
    
    func testDataLatestQuote() async throws {
        _ = try await client.data.latestQuote(symbol: "AAPL")
    }
    
    func testDataLatestSnapshot() async throws {
        let snapshot = try await client.data.snapshots(symbols: ["AAPL"])
        print(snapshot)
    }

    func testDataBarsMultiRequest() async throws {
        _ = _ = try await client.data.bars(.oneDay, symbols: ["AAPL", "FSLY"], limit: 1)
    }
    
    func testScreenerLastestMovers() async throws {
        let movers = try await client.data.marketMovers(type: .stocks, limit: 3)
        print(movers)
    }
    
    func testScreenerMostActive() async throws {
        let active = try await client.data.mostActive(by: .trades, limit: 5)
        print(active)
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
