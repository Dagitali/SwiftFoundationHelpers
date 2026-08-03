//
//  BundleExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Bundle` extensions.

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

/// A test suite to validate the functionality of  `Bundle` extensions.
@Suite("BundleExtensions Tests")
struct BundleExtensionsTests {
    // MARK: JSON

    /// Tests the `decode()` method.
    ///
    /// This ensures the method correctly decodes the JSON file into the
    /// expected model.
    @Test
    func decode() {
        // Given...
        let decodedModel = Bundle.module.decode(
            "example.json",
            as: MockModel.self
        )

        // Then...
        #expect(
            decodedModel != nil,
            "Decoded model should not be nil."
        )
        #expect(
            decodedModel == MockModel(id: 1, name: "Test Object"),
            "Decoded model does not match expected value."
        )
    }

    /// Tests that the source-compatible overload returns `nil` for a missing
    /// resource.
    @Test
    func decodeMissingResourceReturnsNil() {
        // Given...
        let decodedModel = Bundle.module.decode(
            "missing.json",
            as: MockModel.self
        )

        // Then...
        #expect(decodedModel == nil)
    }

    /// Tests that a missing bundled resource produces a structured error.
    @Test
    func decodeMissingResourceThrows() {
        // Then...
        #expect(throws: BundleResourceError.self) {
            let _: MockModel = try Bundle.module.decode(
                "missing.json",
                as: MockModel.self,
                using: JSONDecoder()
            )
        }
    }

    /// Tests the throwing overload with a caller-supplied decoder.
    @Test
    func decodeUsingDecoder() throws {
        // Given...
        let decodedModel = try Bundle.module.decode(
            "example.json",
            as: MockModel.self,
            using: JSONDecoder()
        )

        // Then...
        #expect(decodedModel == MockModel(id: 1, name: "Test Object"))
    }
}
