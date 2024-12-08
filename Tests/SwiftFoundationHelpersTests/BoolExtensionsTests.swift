//
//  BoolExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Bool` extensions.
*/

import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `Bool` extensions.
@Suite("BoolExtensions Tests")
struct BoolExtensionsTests {
    /// Test for toggling the boolean value.
    @Test
    func testToggle() {
        var flag = true
        flag.toggle()
        #expect(flag == false)
        flag.toggle()
        #expect(flag == true)
    }
}
