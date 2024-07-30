// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "EditBingo",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "EditBingo",
            targets: ["EditBingo"]),
    ],
    dependencies: [
        .package(path: "../SharedUI"),
        .package(path: "../Services")
    ],
    targets: [
        .target(
            name: "EditBingo",
            dependencies: [
                .product(name: "SharedUI", package: "SharedUI"),
                .product(name: "BingoServices", package: "Services")
            ],
            path: "Sources"
        )
    ]
)
