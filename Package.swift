// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Alpaca",
    platforms: [
        .iOS("15.0"),
        .macOS("12.0"),
        .tvOS("15.0"),
        .watchOS("8.0")
    ],
    products: [
        .library(name: "Alpaca", targets: ["Alpaca"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Alpaca",
            dependencies: []
        ),
        .testTarget(
            name: "AlpacaTests",
            dependencies: ["Alpaca"]
        )
    ],
    swiftLanguageVersions: [.version("5.5")]
)
