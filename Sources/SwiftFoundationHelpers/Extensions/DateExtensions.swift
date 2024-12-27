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
    /// print(tomorrow)  // Next day
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
    /// print(nextMonth)  // Same day, next month
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
    /// print(tenSecondsLater)  // 10 seconds from now
    /// ```
    ///
    /// - Parameter seconds: The number of seconds to add.
    /// - Returns: A new `Date` object with the specified number of seconds added.
    func addingSeconds(_ seconds: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }

    // MARK: Integer Conversions

    /// Returns the day of the week for the date as an integer.
    ///
    /// Example:
    /// ```swift
    /// let date = Date()        // Assume today is Tuesday
    /// print(date.dayOfWeek())  // 3
    /// ```
    ///
    /// - Returns: An integer representing the day of the week (1 = Sunday, 2 = Monday, ..., 7 = Saturday).
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }

    // MARK: String Conversions

    /// Formats the date into a string using the specified format.
    ///
    /// - Parameter format: A string representing the date format (default is "yyyy-MM-dd HH:mm:ss").
    /// - Returns: A formatted string representation of the date.
    func formatted(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
