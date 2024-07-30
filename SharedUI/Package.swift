// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SharedUI",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SharedUI",
            targets: ["SharedUI"]),
    ],
    dependencies: [
        .package(path: "../Resources")
    ],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: [
                .product(name: "Resources", package: "Resources")
            ],
            path: "Sources"
        )
    ]
)
