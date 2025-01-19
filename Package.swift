// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFoundationHelpers",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        // .visionOS(.v1),
        .watchOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to
        // other packages.
        .library(
            name: "SwiftFoundationHelpers",
            targets: ["SwiftFoundationHelpers"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftFoundationHelpers"),
        .testTarget(
            name: "StringExtensionsTests",
            dependencies: ["SwiftFoundationHelpers"]
        ),
    ]
)
