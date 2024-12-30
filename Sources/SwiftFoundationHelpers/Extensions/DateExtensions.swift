//
//  DateExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `Date` types.
*/

import Foundation

// MARK: - Public

public extension Date {
    // MARK: Arithmetic

    /// Returns a new date by adding the specified number of days to the current date.
    ///
    /// Example:
    /// ```swift
    /// let date = Date()
    /// let tomorrow = date.addingDays(1)
    /// print(tomorrow) // Next day
    /// ```
    ///
    /// - Parameter days: The number of days to add.
    /// - Returns: A new `Date` object with the specified number of days added.
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Returns a new date by adding the specified number of months to the current date.
    ///
    /// Example:
    /// ```swift
    /// let date = Date()
    /// let nextMonth = date.addingMonths(1)
    /// print(nextMonth) // Same day, next month
    /// ```
    ///
    /// - Parameter months: The number of months to add.
    /// - Returns: A new `Date` object with the specified number of months added.
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    /// Returns a new date by adding the specified number of seconds to the current date.
    ///
    /// Example:
    /// ```swift
    /// let date = Date()
    /// let tenSecondsLater = date.addingSeconds(10)
    /// print(tenSecondsLater) // 10 seconds from now
    /// ```
    ///
    /// - Parameter seconds: The number of seconds to add.
    /// - Returns: A new `Date` object with the specified number of seconds added.
    func addingSeconds(_ seconds: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }

    // MARK: Checks

    /// Checks if the date is in the future.
    ///
    /// Example:
    /// ```swift
    /// let currentDate = Date()
    /// let futureDate = currentDate.addingTimeInterval(3600)
    /// let pastDate = currentDate.addingTimeInterval(-3600)
    /// print(futureDate.isInFuture) // Output: true
    /// print(pastDate.isInFuture) // Output: false
    /// print(currentDate.isInFuture) // Output: false
    /// ```
    ///
    /// - Returns: A Boolean value indicating whether the date is in the future.
    var isInFuture: Bool {
        self > Date()
    }

    /// Checks if two dates fall on the same calendar day.
    ///
    /// Example:
    /// ```swift
    /// let dateComponents = DateComponents(year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0)
    /// let date = Calendar.current.date(from: dateComponents)!
    /// let sameDate = date.addingTimeInterval(3600 * 23)
    /// let nextDate = date.addingTimeInterval(3600 * 24)
    /// print(date.isSameDay(as: sameDate)) // Output: true
    /// print(date.isSameDay(as: nextDate)) // Output: false
    /// ```
    ///
    /// - Parameter otherDate: The date to compare.
    /// - Returns: A Boolean value indicating whether the two dates are on the same calendar day.
    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    // MARK: Conversions (Integer)

    /// Returns the day of the week for the date as an integer.
    ///
    /// Example:
    /// ```swift
    /// let date = Date() // Assume today is Tuesday
    /// print(date.dayOfWeek()) // Output: 3
    /// ```
    ///
    /// - Returns: An integer representing the day of the week (1 = Sunday, 2 = Monday, ..., 7 = Saturday).
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }

    // MARK: Conversions (String)

    /// Formats the date into a string using the specified format.
    ///
    /// Example:
    /// ```swift
    /// let date = Date()
    /// let defaultFormattedDate = date.formatted()
    /// print(defaultFormattedDate) // Output: "2024-12-28 15:30:00"
    ///
    /// let customFormattedDate = date.formatted("MMM d, yyyy")
    /// print(customFormattedDate) // Output: "Dec 28, 2024"
    ///
    /// let timeOnly = date.formatted("HH:mm:ss")
    /// print(timeOnly) // Output: "15:30:00"
    /// ```
    ///
    /// - Parameter format: A string representing the date format (default is "yyyy-MM-dd HH:mm:ss").
    /// - Parameter timeZone: The timezone to use for the formatted date (default is the current timezone).
    /// - Returns: A formatted string representation of the date.
    func formatted(_ format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
