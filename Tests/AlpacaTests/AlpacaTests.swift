import XCTest
@testable import Alpaca

#if canImport(Combine)
import Combine
#else
import OpenCombine
import OpenCombineFoundation
#endif

final class AlpacaTests: XCTestCase {

    let client = AlpacaClient(.paper(key: "PKK2C6KSTTVGJ039BQ6B", secret: "FCWBZhzJiobxDpDjThXZFeCfYgZRXJ97OxiDWatu"))

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

    static var allTests = [
        ("testAccountRequest", testAssetsRequest),
        ("testAccountConfigurationsRequest", testAccountConfigurationsRequest),
        ("testAccountConfigurationsUpdateRequest", testAccountConfigurationsUpdateRequest),
        ("testAssetsRequest", testAssetsRequest),
        ("testAssetSymbolRequest", testAssetSymbolRequest),
        ("testClientAPI", testClientAPI),
        ("testCalendarRequest", testCalendarRequest),
        ("testClockRequest", testClockRequest),
        ("testPortfolioHistoryRequest", testPortfolioHistoryRequest)
    ]
}
