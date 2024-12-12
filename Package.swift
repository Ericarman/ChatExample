// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HealthChatExample",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HealthChatExample",
            targets: ["HealthChatExample"]
        ),
        .library(
            name: "HealthChatExampleDynamic",
            type: .dynamic,
            targets: ["HealthChatExample"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/exyte/Chat.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "HealthChatExample",
            dependencies: [
                .product(name: "ExyteChat", package: "Chat")
            ],
            path: "HealthChat/Sources"
        ),
    ]
)
