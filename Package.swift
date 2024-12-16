// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HealthChatExample",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "HealthChatExample",
            targets: ["HealthChatExample"]
        ),
//        .library(
//            name: "HealthChatExampleDynamic",
//            type: .dynamic,
//            targets: ["HealthChatExample"]
//        ),
    ],
    dependencies: [
        .package(url: "https://github.com/EnesKaraosman/SwiftyChat.git", branch: "master")
    ],
    targets: [
        .target(
            name: "HealthChatExample",
            dependencies: [
                .product(name: "SwiftyChat", package: "SwiftyChat")
            ],
            path: "HealthChat/Sources"
        ),
    ]
)
