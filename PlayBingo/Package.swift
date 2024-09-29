// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PlayBingo",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "PlayBingo",
            targets: ["PlayBingo"])
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(path: "../Resources"),
        .package(path: "../Contracts")
    ],
    targets: [
        .target(
            name: "PlayBingo",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "ServicesContracts", package: "Contracts"),
                .product(name: "Resources", package: "Resources")
            ],
            path: "Sources"
        )
    ]
)
