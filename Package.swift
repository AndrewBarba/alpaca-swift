// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Alpaca",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "Alpaca", targets: ["Alpaca"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.10.0")
    ],
    targets: [
        .target(
            name: "Alpaca",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "OpenCombine", package: "OpenCombine"),
                .product(name: "OpenCombineDispatch", package: "OpenCombine"),
                .product(name: "OpenCombineFoundation", package: "OpenCombine")
            ]
        ),
        .testTarget(
            name: "AlpacaTests",
            dependencies: ["Alpaca"]
        )
    ]
)
