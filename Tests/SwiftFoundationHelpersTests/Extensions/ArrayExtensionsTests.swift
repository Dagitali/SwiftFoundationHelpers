//
//  ArrayExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Array` extensions.
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `Array` extensions.
@Suite("ArrayExtensions Tests")
struct ArrayExtensionsTests {
    /// Tests the `removingDuplicates()` method.
    ///
    /// This ensures it correctly cremoves duplicate elements from arrays.
    @Test
    func removingDuplicates() {
        #expect([1, 2, 2, 3].removingDuplicates() == [1, 2, 3])
        #expect(["a", "b", "b", "a"].removingDuplicates() == ["a", "b"])
        #expect([].removingDuplicates() == [String]())
    }
}
