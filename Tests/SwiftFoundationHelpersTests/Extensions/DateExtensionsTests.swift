//
//  DateExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
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
    // MARK: Private Fixtures

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private var referenceDate: Date {
        calendar.date(
            from: DateComponents(
                year: 1970,
                month: 1,
                day: 1,
                hour: 0,
                minute: 0,
                second: 0
            )
        )!
    }

    // MARK: Arithmetic

    /// Tests the `addingDays()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of days to the current date.
    @Test
    func addingDays() throws {
        let result = try #require(
            referenceDate.addingDays(7, calendar: calendar)
        )

        #expect(calendar.dateComponents([.year, .month, .day], from: result).day == 8)
    }

    /// Tests the `addingMonths()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of months to the current date.
    @Test
    func addingMonths() throws {
        let result = try #require(
            referenceDate.addingMonths(1, calendar: calendar)
        )

        #expect(calendar.dateComponents([.year, .month], from: result).month == 2)
    }

    /// Tests the `addingSeconds()` method.
    ///
    /// This ensures the method correctly returns a new date by adding the
    /// specified number of seconds to the current date.
    @Test
    func addingSeconds() throws {
        let result = try #require(
            referenceDate.addingSeconds(
                60,
                calendar: calendar
            )
        )

        #expect(calendar.dateComponents([.minute], from: result).minute == 1)
    }

    /// Verifies that the original arithmetic signatures remain available.
    @Test
    func sourceCompatibleArithmetic() {
        #expect(referenceDate.addingDays(0) == referenceDate)
        #expect(referenceDate.addingMonths(0) == referenceDate)
        #expect(referenceDate.addingSeconds(0) == referenceDate)
    }

    // MARK: Checks

    /// Tests the `isInFuture()` method.
    ///
    /// This ensures the method correctly checks if the date is in the future.
    @Test
    func isInFuture() {
        let futureDate = referenceDate.addingTimeInterval(3600)
        let pastDate = referenceDate.addingTimeInterval(-3600)

        #expect(futureDate.isInFuture(relativeTo: referenceDate))
        #expect(!pastDate.isInFuture(relativeTo: referenceDate))
        #expect(!referenceDate.isInFuture(relativeTo: referenceDate))
    }

    /// Tests the `isSameDay()` method.
    ///
    /// This ensures the method correctly checks if two dates fall on the same
    /// calendar day.
    @Test
    func isSameDay() {
        let sameDate = referenceDate.addingTimeInterval(3600 * 23)
        let nextDate = referenceDate.addingTimeInterval(3600 * 24)

        #expect(referenceDate.isSameDay(as: sameDate, calendar: calendar))
        #expect(!referenceDate.isSameDay(as: nextDate, calendar: calendar))
    }

    /// Verifies that the original check signatures remain available.
    @Test
    func sourceCompatibleChecks() {
        #expect(Date.distantFuture.isInFuture)
        #expect(!Date.distantPast.isInFuture)
        #expect(referenceDate.isSameDay(as: referenceDate))
    }

    // MARK: Conversions (Integer)

    /// Tests the `dayOfWeek()` method.
    ///
    /// This ensures the method correctly returns the day of the week for the
    /// date as an integer.
    @Test
    func dayOfWeek() {
        #expect(referenceDate.dayOfWeek(in: calendar) == 5)
    }

    /// Verifies that the original weekday property remains available.
    @Test
    func sourceCompatibleDayOfWeek() {
        #expect((1...7).contains(referenceDate.dayOfWeek))
    }

    // MARK: Conversions (String)

    /// Tests the `formatted()` method.
    ///
    /// This ensures the method correctly formatted dates into a strings using
    /// specified formats.
    @Test
    func formatted() {
        let utc = TimeZone(identifier: "UTC")!
        let locale = Locale(identifier: "en_US_POSIX")

        let date1 = Date(timeIntervalSince1970: 0)  // Jan 1, 1970
        #expect(
            date1.formatted(
                "yyyy-MM-dd",
                timeZone: utc,
                locale: locale,
                calendar: calendar
            ) == "1970-01-01"
        )
        #expect(
            date1.formatted(
                "MMM dd, yyyy",
                timeZone: utc,
                locale: locale,
                calendar: calendar
            ) == "Jan 01, 1970"
        )

        let date2 = Date(timeIntervalSince1970: 3600 * 24)  // Jan 2, 1970
        #expect(
            date2.formatted(
                "yyyy-MM-dd",
                timeZone: utc,
                locale: locale,
                calendar: calendar
            ) == "1970-01-02"
        )
        #expect(
            date2.formatted(
                "MMM dd, yyyy",
                timeZone: utc,
                locale: locale,
                calendar: calendar
            ) == "Jan 02, 1970"
        )
    }

    /// Verifies that the original formatting signature remains available.
    @Test
    func sourceCompatibleFormatting() {
        let utc = TimeZone(secondsFromGMT: 0)!

        #expect(
            referenceDate.formatted("yyyy-MM-dd", timeZone: utc)
                == "1970-01-01"
        )
    }
}
