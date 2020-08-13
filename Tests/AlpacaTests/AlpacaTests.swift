import XCTest
@testable import Alpaca

final class AlpacaTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Alpaca().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
