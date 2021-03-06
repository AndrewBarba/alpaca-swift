import XCTest
import OpenCombine
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

    private var bag = Set<AnyCancellable>()

    func testClientAPI() {
        XCTAssertEqual(client.environment.api, "https://paper-api.alpaca.markets/v2")
    }

    func testAccountRequest() {
        let exp = XCTestExpectation()
        client.account()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testAccountConfigurationsRequest() {
        let exp = XCTestExpectation()
        client.accountConfigurations()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testAccountConfigurationsUpdateRequest() {
        let exp = XCTestExpectation()
        client.saveAccountConfigurations(dtbpCheck: .exit)
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testAssetsRequest() {
        let exp = XCTestExpectation()
        client.assets(status: .inactive)
            .assertNoFailure()
            .map { $0.prefix(5) }
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testAssetSymbolRequest() {
        let exp = XCTestExpectation()
        client.asset(symbol: "AAPL")
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testClockRequest() {
        let exp = XCTestExpectation()
        client.clock()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testCalendarRequest() {
        let exp = XCTestExpectation()
        client.calendar(start: "2020-01-01", end: "2020-01-07")
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testPortfolioHistoryRequest() {
        let exp = XCTestExpectation()
        client.portfolioHistory()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testPositionsRequest() {
        let exp = XCTestExpectation()
        client.positions()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testClosePositionsRequest() {
        let exp = XCTestExpectation()
        client.closePositions()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testOrdersRequest() {
        let exp = XCTestExpectation()
        client.orders()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testCreateOrderRequest() {
        let exp = XCTestExpectation()
        client.createOrder(symbol: "AAPL", qty: 2, side: .buy, type: .market, timeInForce: .day)
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testCancelOrdersRequest() {
        let exp = XCTestExpectation()
        client.cancelOrders()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testWatchlistsRequest() {
        let exp = XCTestExpectation()
        client.watchlists()
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testCreateAndDeleteWatchlistRequest() {
        let exp = XCTestExpectation()
        client.createWatchlist(name: "[Swift] \(UUID().uuidString)", symbols: ["AAPL"])
            .assertNoFailure()
            .print()
            .flatMap {
                self.client.deleteWatchlist(id: $0.id).assertNoFailure()
            }
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testDataBarsRequest() {
        let exp = XCTestExpectation()
        client.data.bars(.oneDay, symbol: "AAPL", limit: 1)
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
    }

    func testDataBarsMultiRequest() {
        let exp = XCTestExpectation()
        client.data.bars(.oneDay, symbols: ["AAPL", "FSLY"], limit: 1)
            .assertNoFailure()
            .print()
            .sink { _ in exp.fulfill() }
            .store(in: &bag)
        wait(for: [exp], timeout: 5)
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
