// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Contracts",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BingoServiceContracts",
            targets: ["BingoServiceContracts"]),
        .library(
            name: "ScreenFactoryContracts",
            targets: ["ScreenFactoryContracts"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "BingoServiceContracts",
            dependencies: [],
            path: "Sources/BingoServiceContracts"
        ),
        .target(
            name: "ScreenFactoryContracts",
            dependencies: [],
            path: "Sources/ScreenFactoryContracts"
        )
    ]
)

