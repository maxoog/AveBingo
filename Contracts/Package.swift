// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Contracts",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ServicesContracts",
            targets: ["ServicesContracts"]),
        .library(
            name: "ScreenFactoryContracts",
            targets: ["ScreenFactoryContracts"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ServicesContracts",
            dependencies: [],
            path: "Sources/ServicesContracts"
        ),
        .target(
            name: "ScreenFactoryContracts",
            dependencies: [],
            path: "Sources/ScreenFactoryContracts"
        )
    ]
)

