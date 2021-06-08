// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Alpaca",
    platforms: [
        .iOS(.init("15.0"))
    ],
    products: [
        .library(name: "Alpaca", targets: ["Alpaca"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Alpaca",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
        .testTarget(
            name: "AlpacaTests",
            dependencies: ["Alpaca"]
        )
    ],
    swiftLanguageVersions: [.version("5.5")]
)
