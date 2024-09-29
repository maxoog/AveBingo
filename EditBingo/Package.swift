// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EditBingo",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "EditBingo",
            targets: ["EditBingo"])
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(path: "../Services"),
        .package(path: "../Contracts")
    ],
    targets: [
        .target(
            name: "EditBingo",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "BingoServices", package: "Services"),
                .product(name: "CommonModels", package: "Contracts")
            ],
            path: "Sources"
        )
    ]
)
