//
//  BundleExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
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
    func testDecode() {
        // Given...
        let decodedModel = Bundle.module.decode("example.json", as: MockModel.self)
        
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
}
