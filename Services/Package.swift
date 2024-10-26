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
            name: "NetworkClient",
            targets: ["NetworkClient"]),
        .library(
            name: "BingoServicesForAppClip",
            targets: ["BingoServicesForAppClip"]),
        .library(
            name: "NetworkCore",
            targets: ["NetworkCore"]),
        .library(
            name: "Analytics",
            targets: ["Analytics"])
    ],
    dependencies: [
        .package(path: "../Contracts"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1"),
        .package(url: "https://github.com/mixpanel/mixpanel-swift.git", exact: "4.3.0")
    ],
    targets: [
        .target(
            name: "BingoServices",
            dependencies: [
                "NetworkClient",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ServicesContracts", package: "Contracts"),
                .product(name: "CommonModels", package: "Contracts"),
                "NetworkCore"
            ],
            path: "Sources/BingoServices"
        ),
        .target(
            name: "NetworkClient",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                "NetworkCore",
                "TokenStorage"
            ],
            path: "Sources/NetworkClient"
        ),
        .target(
            name: "BingoServicesForAppClip",
            dependencies: [
                .product(name: "ServicesContracts", package: "Contracts"),
                .product(name: "CommonModels", package: "Contracts"),
                "NetworkCore"
            ],
            path: "Sources/BingoServicesForAppClip"
        ),
        .target(
            name: "NetworkCore",
            dependencies: [
                .product(name: "CommonModels", package: "Contracts"),
                .product(name: "ServicesContracts", package: "Contracts")
            ],
            path: "Sources/NetworkCore"
        ),
        .target(
            name: "Analytics",
            dependencies: [
                .product(name: "Mixpanel", package: "mixpanel-swift"),
                .product(name: "ServicesContracts", package: "Contracts")
            ],
            path: "Sources/Analytics"
        ),
        .target(
            name: "TokenStorage",
            dependencies: [],
            path: "Sources/TokenStorage"
        ),
        .testTarget(
            name: "NetworkCoreTests",
            dependencies: [
                "NetworkCore"
            ],
            path: "Tests/NetworkCoreTests"
        )
    ]
)
