// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "BingoServices",
            targets: ["BingoServices"]),
        .library(
            name: "NetworkCore",
            targets: ["NetworkCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        .target(
            name: "BingoServices",
            dependencies: [
                "NetworkCore",
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources/BingoServices"
        ),
        .target(
            name: "NetworkCore",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources/NetworkCore"
        )
    ]
)

