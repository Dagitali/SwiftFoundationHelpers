// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftFoundationHelpers",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to
        // other packages.
        .library(
            name: "SwiftFoundationHelpers",
            targets: ["SwiftFoundationHelpers"]),
    ],
    dependencies: [
        // Other dependencies.
        .package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.3"),
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
