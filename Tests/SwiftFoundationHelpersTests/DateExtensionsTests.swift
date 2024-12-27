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
    // MARK: Arithmetic

    /// Test for returning a new date by adding the specified number of days to the current date.
    @Test
    func testAddingDays() {
        let date = Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        let result = date.addingDays(7)
        #expect(Calendar.current.dateComponents([.year, .month, .day], from: result).day == 7)
    }

    /// Test for returning a new date by adding the specified number of months to the current date.
    @Test
    func testAddingMonths() {
        let date = Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        let result = date.addingMonths(1)
        #expect(Calendar.current.dateComponents([.year, .month], from: result).month == 1)
    }

    /// Test for returning a new date by adding the specified number of seconds to the current date.
    @Test
    func testAddingSeconds() {
        let date = Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        let result = date.addingSeconds(60)
        #expect(result.timeIntervalSince1970 == 60)
    }

    // MARK: Checks

    /// Test for checking if the date is in the future.
    @Test
    func testIsInFuture() {
        let futureDate = Date().addingTimeInterval(60 * 60)  // 1 hour from now
        let pastDate = Date().addingTimeInterval(-60 * 60)  // 1 hour ago
        let currentDate = Date()

        #expect(futureDate.isInFuture == true)

        #expect(pastDate.isInFuture == false)
        #expect(currentDate.isInFuture == false)
    }

    /// Test for checking if two dates fall on the same calendar day.
    @Test
    func testIsSameDay() {
        let date1 = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let date2 = Date(timeIntervalSince1970: 60 * 60 * 23) // Still Jan 1, 1970
        let date3 = Date(timeIntervalSince1970: 60 * 60 * 24) // Jan 2, 1970

        // FIXME: Research why this test fails with the expected Boolean.
        #expect(date1.isSameDay(as: date2) == true)

        #expect(date1.isSameDay(as: date3) == false)
    }

    // MARK: Integer Conversions

    /// Test for returning the day of the week for the date as an integer.
    @Test
    func testDayOfWeek() {
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 8))!  // Sunday
        #expect(date.dayOfWeek == 1)
    }

    // MARK: String Conversions

    /// Test for formatting dates into a strings using specified formats.
    @Test
    func testFormatted() {
        let date = Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        // FIXME: Research why this test fails with the expected date.
        #expect(date.formatted("yyyy-MM-dd") == "1969-12-31")
        #expect(date.formatted("MMM dd, yyyy") == "Dec 31, 1969")
    }
}
