// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Archive",
    defaultLocalization: "kr",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Archive",
            targets: [
                "Archive"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactorKit/ReactorKit", exact: "3.2.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "3.3.0"),
        // Test
        .package(url: "https://github.com/Quick/Quick", exact: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble", exact: "10.0.0")
    ],
    targets: [
        .target(
            name: "Archive",
            dependencies: [
                "ReactorKit",
                .product(name: "Lottie", package: "lottie-ios")
            ]
        ),
        .testTarget(
            name: "ArchiveTests",
            dependencies: [
                "Archive",
                "Quick",
                "Nimble"
            ]
        )
    ]
)
