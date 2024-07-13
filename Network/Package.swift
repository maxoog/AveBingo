// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.1")
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "Sources"
        )
    ]
)

