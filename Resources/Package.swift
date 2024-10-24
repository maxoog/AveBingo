// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Resources",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Resources",
            type: .dynamic,
            targets: ["Resources"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Resources",
            dependencies: [],
            path: "Sources",
            resources: [.process("Fonts")]
        )
    ]
)
