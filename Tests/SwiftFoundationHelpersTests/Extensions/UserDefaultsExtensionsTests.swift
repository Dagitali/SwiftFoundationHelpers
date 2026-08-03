//
//  UserDefaultsExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `UserDefaults` extensions.

 References:
 1. https://developer.apple.com/documentation/testing/migratingfromxctest
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Fixtures

private struct MockModel: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Test Suites

/// A test suite to validate the functionality of  `UserDefaults` extensions.
@Suite("UserDefaultsExtensions Tests")
struct UserDefaultsExtensionsTests {
    // MARK: Keys

    /// Tests the `isFirstLaunch()` enum case.
    ///
    /// This ensures the key exposes its expected stable string value.
    @Test
    func isFirstLaunch() {
        // Given...
        let expected = "isFirstLaunch"

        // When...
        let actual = UserDefaults.Key.isFirstLaunch

        // Then...
        #expect(
            actual == expected,
            """
            "The key should be "\(expected)", not "\(actual)".
            """
        )
    }
}
