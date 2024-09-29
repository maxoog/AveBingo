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
        .library(
            name: "CommonModels",
            targets: ["CommonModels"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ServicesContracts",
            dependencies: [
                "CommonModels"
            ],
            path: "Sources/ServicesContracts"
        ),
        .target(
            name: "ScreenFactoryContracts",
            dependencies: [
                "ServicesContracts",
                "CommonModels"
            ],
            path: "Sources/ScreenFactoryContracts"
        ),
        .target(
            name: "CommonModels",
            dependencies: [
            ],
            path: "Sources/CommonModels"
        )
    ]
)
