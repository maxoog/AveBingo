// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "BingoHistory",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BingoHistory",
            targets: ["BingoHistory"]),
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(path: "../Services"),
        .package(path: "../Resources"),
        .package(path: "../Contracts")
    ],
    targets: [
        .target(
            name: "BingoHistory",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "BingoServices", package: "Services"),
                .product(name: "Resources", package: "Resources"),
                .product(name: "ScreenFactoryContracts", package: "Contracts")
            ],
            path: "Sources"
        )
    ]
)



