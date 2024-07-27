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
            targets: ["NetworkCore"])
    ],
    dependencies: [
        .package(path: "../Contracts"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        .target(
            name: "BingoServices",
            dependencies: [
                "NetworkClient",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "BingoServiceContracts", package: "Contracts"),
                "NetworkCore"
            ],
            path: "Sources/BingoServices"
        ),
        .target(
            name: "NetworkClient",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                "NetworkCore"
            ],
            path: "Sources/NetworkClient"
        ),
        .target(
            name: "BingoServicesForAppClip",
            dependencies: [
                .product(name: "BingoServiceContracts", package: "Contracts"),
                "NetworkCore"
            ],
            path: "Sources/BingoServicesForAppClip"
        ),
        .target(
            name: "NetworkCore",
            dependencies: [],
            path: "Sources/NetworkCore"
        )
    ]
)

