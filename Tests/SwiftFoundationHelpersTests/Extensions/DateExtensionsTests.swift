//
//  DateExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

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
    // MARK: Fixtures

    private let dateComponents = DateComponents(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0)

    // MARK: Arithmetic

    /// Tests the `addingDays()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of days to the current date.
    @Test
    func testAddingDays() {
        let date = Calendar.current.date(from: dateComponents)!
        let result = date.addingDays(7)

        #expect(Calendar.current.dateComponents([.year, .month, .day], from: result).day == 8)
    }

    /// Tests the `addingMonths()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of months to the current date.
    @Test
    func testAddingMonths() {
        let date = Calendar.current.date(from: dateComponents)!
        let result = date.addingMonths(1)

        #expect(Calendar.current.dateComponents([.year, .month], from: result).month == 2)
    }

    /// Tests the `addingSeconds()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of seconds to the current date.
    @Test
    func testAddingSeconds() {
        let date = Calendar.current.date(from: dateComponents)!
        let result = date.addingSeconds(60)

        #expect(Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: result).minute == 1)
    }

    // MARK: Checks

    /// Tests the `isInFuture()` method.
    ///
    /// This ensures the method correctly checks if the date is in the future.
    @Test
    func testIsInFuture() {
        let currentDate = Date()
        let futureDate = currentDate.addingTimeInterval(3600) // 1 hour from now
        let pastDate = currentDate.addingTimeInterval(-3600) // 1 hour ago

        #expect(futureDate.isInFuture == true)

        #expect(pastDate.isInFuture == false)
        #expect(currentDate.isInFuture == false)
    }

    /// Tests the `isSameDay()` method.
    ///
    /// This ensures the method correctly checks if two dates fall on the same
    /// calendar day.
    @Test
    func testIsSameDay() {
        let date = Calendar.current.date(from: dateComponents)!
        let sameDate = date.addingTimeInterval(3600 * 23) // Jan 1, 1970
        let nextDate = date.addingTimeInterval(3600 * 24) // Jan 2, 1970

        #expect(date.isSameDay(as: sameDate) == true)

        #expect(date.isSameDay(as: nextDate) == false)
    }

    // MARK: Conversions (Integer)

    /// Tests the `dayOfWeek()` method.
    ///
    /// This ensures the method correctly returns the day of the week for the
    /// date as an integer.
    @Test
    func testDayOfWeek() {
        let date = Calendar.current.date(from: dateComponents)! // Thursday

        #expect(date.dayOfWeek == 5)
    }

    // MARK: Conversions (String)

    /// Tests the `formatted()` method.
    ///
    /// This ensures the method correctly formatted dates into a strings using
    /// specified formats.
    @Test
    func testFormatted() {
        let utc = TimeZone(identifier: "UTC")!

        let date1 = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        #expect(date1.formatted("yyyy-MM-dd", timeZone: utc) == "1970-01-01")
        #expect(date1.formatted("MMM dd, yyyy", timeZone: utc) == "Jan 01, 1970")

        let date2 = Date(timeIntervalSince1970: 3600 * 24) // Jan 2, 1970
        #expect(date2.formatted("yyyy-MM-dd", timeZone: utc) == "1970-01-02")
        #expect(date2.formatted("MMM dd, yyyy", timeZone: utc) == "Jan 02, 1970")
    }
}
