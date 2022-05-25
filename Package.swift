// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Oovvuu Player SDK",
    platforms: [
            .iOS(.v14)
        ],
    products: [
        .library(
            name: "OovvuuPlayerSDK",
            targets: ["OovvuuPlayerSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/brightcove/brightcove-player-sdk-ios.git", from: "6.10.5"),
    ],
    targets: [
            .binaryTarget(
                    name: "OovvuuPlayerSDK",
                    path: "xcframework/dynamic/OovvuuPlayerSDK.xcframework"
                )
        ]
)
