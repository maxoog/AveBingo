// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PlayBingo",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "PlayBingo",
            targets: ["PlayBingo"]),
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(path: "../Network")
    ],
    targets: [
        .target(
            name: "PlayBingo",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "Network", package: "Network")
            ],
            path: "Sources"
        )
    ]
)


