// swift-tools-version:5.7
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
        .package(url: "https://github.com/wlsdms0122/Reducer.git", exact: "2.1.0"),
        .package(url: "https://github.com/wlsdms0122/Compose.git", exact: "1.6.1"),
        .package(url: "https://github.com/wlsdms0122/JSToast.git", exact: "2.6.6"),
        .package(url: "https://github.com/wlsdms0122/Storage.git", exact: "1.2.0"),
        .package(url: "https://github.com/wlsdms0122/Validator.git", exact: "1.0.3"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", exact: "3.2.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "3.3.0")
    ],
    targets: [
        .target(
            name: "Archive",
            dependencies: [
                "Reducer",
                "Compose",
                "JSToast",
                "Storage",
                "Validator",
                "ReactorKit",
                .product(name: "Lottie", package: "lottie-ios")
            ]
        ),
        .testTarget(
            name: "ArchiveTests",
            dependencies: [
                "Archive"
            ]
        )
    ]
)
