//
//  StringExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `String` extensions.
*/

import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `String` extensions.
@Suite("StringExtensions Tests")
struct StringExtensionsTests {
    /// Test for determining whether the string matches a given regular expression pattern.
    @Test
    func testMatches() {
        #expect("abc123".matches("\\w+\\d+") == true)
        #expect("123abc".matches("^\\d+$") == false)
        #expect("".matches(".+") == false)
    }

    /// Test for trimming leading and trailing whitespace and newline characters from the string.
    @Test
    func testTrimmed() {
        #expect("  hello  ".trimmed() == "hello")
        #expect("\n\nworld\n\n".trimmed() == "world")
        #expect("".trimmed() == "")
    }
}
