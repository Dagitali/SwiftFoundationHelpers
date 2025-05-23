// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
    name: "SwiftFoundationHelpers",
    platforms: [
        .iOS(.v18),
        .macCatalyst(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .visionOS(.v2),
        .watchOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces,
        // making them visible to other packages.
        .library(
            name: "SwiftFoundationHelpers",
            targets: ["SwiftFoundationHelpers"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a
        // module or a test suite.  Targets can depend on other targets in this
        // package and products from dependencies.

        // Main module
        .target(
            name: "SwiftFoundationHelpers"
        ),

        // Unit tests
        .testTarget(
            name: "SwiftFoundationHelpersTests",
            dependencies: ["SwiftFoundationHelpers"],
            resources: [
                .process("Resources")  // Includes `Resources` folder for use in tests.
            ]
        ),

        // Integration tests
        /*
        .testTarget(
            name: "SwiftFoundationHelpersIntegrationTests",
            dependencies: ["SwiftFoundationHelpers"]
        )
        */
    ]
)
