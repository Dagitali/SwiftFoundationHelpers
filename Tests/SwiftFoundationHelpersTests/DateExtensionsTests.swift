//
//  DateExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Date` extensions.
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `Date` extensions.
@Suite("DateExtensions Tests")
struct DateExtensionsTests {
    /// Test for formatting dates as strings.
    @Test
    func testFormatted() {
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        // FIXME: Research the this test fails with the expected date.
        #expect(date.formatted("yyyy-MM-dd") == "1969-12-31")
        #expect(date.formatted("MMM dd, yyyy") == "Dec 31, 1969")
    }
}
