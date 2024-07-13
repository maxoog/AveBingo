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
    ],
    targets: [
        .target(
            name: "SharedUI",
            dependencies: [],
            path: "Sources"
        )
    ]
)
