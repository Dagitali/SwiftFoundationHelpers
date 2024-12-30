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
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let result = date.addingDays(7)
        #expect(Calendar.current.dateComponents([.year, .month, .day], from: result).day == 7)
    }

    /// Test for returning a new date by adding the specified number of months to the current date.
    @Test
    func testAddingMonths() {
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let result = date.addingMonths(1)
        #expect(Calendar.current.dateComponents([.year, .month], from: result).month == 1)
    }

    /// Test for returning a new date by adding the specified number of seconds to the current date.
    @Test
    func testAddingSeconds() {
        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let result = date.addingSeconds(60)
        #expect(result.timeIntervalSince1970 == 60)
    }

    // MARK: Checks

    /// Test for checking if the date is in the future.
    @Test
    func testIsInFuture() {
        let futureDate = Date().addingTimeInterval(3600) // 1 hour from now
        let pastDate = Date().addingTimeInterval(-3600) // 1 hour ago
        let currentDate = Date()

        #expect(futureDate.isInFuture == true)

        #expect(pastDate.isInFuture == false)
        #expect(currentDate.isInFuture == false)
    }

    /// Test for checking if two dates fall on the same calendar day.
    @Test
    func testIsSameDay() {
        let offset = TimeZone.current.secondsFromGMT() / 3600

        let date = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        let sameDate = date.addingSeconds(3600 * ((23 - offset) % 24)) // Jan 1, 1970
        let nextDate = date.addingSeconds(3600 * ((24 - offset) % 24)) // Jan 2, 1970

        #expect(date.isSameDay(as: sameDate) == true)

        #expect(date.isSameDay(as: nextDate) == false)
    }

    // MARK: Conversions (Integer)

    /// Test for returning the day of the week for the date as an integer.
    @Test
    func testDayOfWeek() {
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 8))!  // Sunday
        #expect(date.dayOfWeek == 1)
    }

    // MARK: Conversions (String)

    /// Test for formatting dates into a strings using specified formats.
    @Test
    func testFormatted() {
        let utc = TimeZone(identifier: "UTC")!

        let date1 = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        #expect(date1.formatted("yyyy-MM-dd", timeZone: utc) == "1970-01-01")
        #expect(date1.formatted("MMM dd, yyyy", timeZone: utc) == "Jan 01, 1970")

        let date2 = Date(timeIntervalSince1970: 60*60*24) // Jan 2, 1970
        #expect(date2.formatted("yyyy-MM-dd", timeZone: utc) == "1970-01-02")
        #expect(date2.formatted("MMM dd, yyyy", timeZone: utc) == "Jan 02, 1970")
    }
}
