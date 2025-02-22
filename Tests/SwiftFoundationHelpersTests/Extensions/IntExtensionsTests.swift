//
//  IntExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Int` extensions.
*/

import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `Int` extensions.
@Suite("IntExtensions Tests")
struct IntExtensionsTests {
    /// Tests the `range()` method.
    ///
    /// This ensures the method correctly converts an integer to a range.
    @Test
    func range() {
        #expect(0.range == 0..<0)
        #expect(5.range == 0..<5)
        #expect(Array(5.range) == [0, 1, 2, 3, 4])
    }

    /// Tests the `times()` method.
    ///
    /// This ensures the method correctly repeats a block of code a number of
    /// times.
    @Test
    func times() {
        var count = 0
        3.times {
            count += 1
        }
        #expect(count == 3)
    }
}
