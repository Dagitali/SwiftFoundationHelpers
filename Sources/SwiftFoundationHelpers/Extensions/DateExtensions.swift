//
//  DateExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with the `Date` type.
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension Date {
    // MARK: Arithmetic

    /// Returns a new date by adding days with the current calendar.
    ///
    /// This source-compatible convenience preserves the original behavior,
    /// including returning this date when the calculation fails. Use
    /// ``addingDays(_:calendar:)`` when calendar choice or failure handling
    /// must be explicit.
    @available(
        *,
        deprecated,
        message: "Use addingDays(_:calendar:) to make calendar behavior explicit."
    )
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Returns a new date by adding the specified number of days to the current date.
    ///
    /// - Parameter days: The number of days to add.
    /// - Parameter calendar: The calendar that defines day boundaries.
    /// - Returns: A new date, or `nil` if the calendar cannot perform the
    ///   calculation.
    ///
    /// ## Example
    /// ```swift
    /// let calendar = Calendar(identifier: .gregorian)
    /// let date = Date()
    /// let tomorrow = date.addingDays(1, calendar: calendar)
    /// print(tomorrow) // Next day
    /// ```
    func addingDays(_ days: Int, calendar: Calendar) -> Date? {
        calendar.date(byAdding: .day, value: days, to: self)
    }

    /// Returns a new date by adding months with the current calendar.
    ///
    /// This source-compatible convenience preserves the original behavior,
    /// including returning this date when the calculation fails. Use
    /// ``addingMonths(_:calendar:)`` when calendar choice or failure handling
    /// must be explicit.
    @available(
        *,
        deprecated,
        message: "Use addingMonths(_:calendar:) to make calendar behavior explicit."
    )
    func addingMonths(_ months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    /// Returns a new date by adding the specified number of months to the current date.
    ///
    /// - Parameter months: The number of months to add.
    /// - Parameter calendar: The calendar that defines month boundaries.
    /// - Returns: A new date, or `nil` if the calendar cannot perform the
    ///   calculation.
    ///
    /// ## Example
    /// ```swift
    /// let calendar = Calendar(identifier: .gregorian)
    /// let date = Date()
    /// let nextMonth = date.addingMonths(1, calendar: calendar)
    /// print(nextMonth) // Same day, next month
    /// ```
    func addingMonths(_ months: Int, calendar: Calendar) -> Date? {
        calendar.date(byAdding: .month, value: months, to: self)
    }

    /// Returns a new date by adding the specified number of seconds to the current date.
    ///
    /// - Parameter seconds: The number of seconds to add.
    /// - Returns: A new `Date` object with the specified number of seconds added.
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// let tenSecondsLater = date.addingSeconds(10)
    /// print(tenSecondsLater) // 10 seconds from now
    /// ```
    @available(
        *,
        deprecated,
        message: "Use addingSeconds(_:calendar:) or addingTimeInterval(_:) to make calculation behavior explicit."
    )
    func addingSeconds(_ seconds: Int) -> Date {
        Calendar.current.date(byAdding: .second, value: seconds, to: self) ?? self
    }

    /// Returns a new date by adding seconds with a caller-supplied calendar.
    ///
    /// - Parameters:
    ///   - seconds: The number of seconds to add.
    ///   - calendar: The calendar used for the calculation.
    /// - Returns: A new date, or `nil` if the calendar cannot perform the
    ///   calculation.
    func addingSeconds(_ seconds: Int, calendar: Calendar) -> Date? {
        calendar.date(byAdding: .second, value: seconds, to: self)
    }

    // MARK: Checks

    /// Indicates whether this date is later than the current instant.
    ///
    /// Use ``isInFuture(relativeTo:)`` when the reference instant must be
    /// deterministic.
    @available(
        *,
        deprecated,
        message: "Use isInFuture(relativeTo:) to supply the reference date explicitly."
    )
    var isInFuture: Bool {
        self > Date()
    }

    /// Checks whether the date is later than a caller-supplied reference date.
    ///
    /// - Parameter referenceDate: The reference instant representing “now.”
    /// - Returns: `true` when this date is later than `referenceDate`.
    ///
    /// ## Example
    /// ```swift
    /// let referenceDate = Date(timeIntervalSince1970: 0)
    /// let futureDate = referenceDate.addingTimeInterval(3600)
    /// print(futureDate.isInFuture(relativeTo: referenceDate))
    /// // Output: true
    /// ```
    func isInFuture(relativeTo referenceDate: Date) -> Bool {
        self > referenceDate
    }

    /// Checks whether two dates fall on the same current-calendar day.
    ///
    /// Use ``isSameDay(as:calendar:)`` when calendar choice must be explicit.
    @available(
        *,
        deprecated,
        message: "Use isSameDay(as:calendar:) to supply the calendar explicitly."
    )
    func isSameDay(as otherDate: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: otherDate)
    }

    /// Checks if two dates fall on the same calendar day.
    ///
    /// - Parameter otherDate: The date to compare.
    /// - Parameter calendar: The calendar that defines day boundaries.
    /// - Returns: A Boolean value indicating whether the two dates are on the
    ///   same calendar day.
    ///
    /// ## Example
    /// ```swift
    /// let dateComponents = DateComponents(
    ///     year: 1970, month: 1, day: 1,
    ///     hour: 0, minute: 0, second: 0
    /// )
    /// let calendar = Calendar(identifier: .gregorian)
    /// let date = calendar.date(from: dateComponents)!
    /// let sameDate = date.addingTimeInterval(3600 * 23)
    /// let nextDate = date.addingTimeInterval(3600 * 24)
    /// print(date.isSameDay(as: sameDate, calendar: calendar))
    /// // Output: true
    /// print(date.isSameDay(as: nextDate, calendar: calendar))
    /// // Output: false
    /// ```
    func isSameDay(as otherDate: Date, calendar: Calendar) -> Bool {
        calendar.isDate(self, inSameDayAs: otherDate)
    }

    // MARK: Conversions (Integer)

    /// Returns the current-calendar weekday number for this date.
    ///
    /// Use ``dayOfWeek(in:)`` when calendar choice must be explicit.
    @available(
        *,
        deprecated,
        message: "Use dayOfWeek(in:) to supply the calendar explicitly."
    )
    var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: self)
    }

    /// Returns the day of the week for the date as an integer.
    ///
    /// - Parameter calendar: The calendar used to calculate the weekday.
    /// - Returns: An integer representing the day of the week (1 = Sunday, 2 =
    ///   Monday, ..., 7 = Saturday).
    ///
    /// ## Example
    /// ```swift
    /// let calendar = Calendar(identifier: .gregorian)
    /// let date = Date() // Assume today is Tuesday
    /// print(date.dayOfWeek(in: calendar)) // Output: 3
    /// ```
    func dayOfWeek(in calendar: Calendar) -> Int {
        calendar.component(.weekday, from: self)
    }

    // MARK: Conversions (String)

    /// Formats the date using the current locale and calendar.
    ///
    /// This source-compatible overload preserves the original defaults. Use
    /// ``formatted(_:timeZone:locale:calendar:)`` when every formatting input
    /// must be deterministic.
    @available(
        *,
        deprecated,
        message: "Use formatted(_:timeZone:locale:calendar:) to supply all formatting context explicitly."
    )
    func formatted(
        _ format: String = "yyyy-MM-dd HH:mm:ss",
        timeZone: TimeZone = .current
    ) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = format

        return formatter.string(from: self)
    }

    /// Formats the date into a string using the specified format.
    ///
    /// - Parameter format: A string representing the date format (default is `yyyy-MM-dd HH:mm:ss`).
    /// - Parameter timeZone: The time zone to use for the formatted date.
    /// - Parameter locale: The locale used for names and formatting rules.
    /// - Parameter calendar: The calendar used to interpret the date.
    /// - Returns: A formatted string representation of the date.
    ///
    /// ## Example
    /// ```swift
    /// let date = Date()
    /// let utc = TimeZone(secondsFromGMT: 0)!
    /// let locale = Locale(identifier: "en_US_POSIX")
    /// let calendar = Calendar(identifier: .gregorian)
    /// let defaultFormattedDate = date.formatted(
    ///     timeZone: utc,
    ///     locale: locale,
    ///     calendar: calendar
    /// )
    /// print(defaultFormattedDate)
    /// // Output: "2024-12-28 15:30:00"
    ///
    /// let customFormattedDate = date.formatted(
    ///     "MMM d, yyyy",
    ///     timeZone: utc,
    ///     locale: locale,
    ///     calendar: calendar
    /// )
    /// print(customFormattedDate)
    /// // Output: "Dec 28, 2024"
    ///
    /// let timeOnly = date.formatted(
    ///     "HH:mm:ss",
    ///     timeZone: utc,
    ///     locale: locale,
    ///     calendar: calendar
    /// )
    /// print(timeOnly)
    /// // Output: "15:30:00"
    /// ```
    func formatted(
        _ format: String = "yyyy-MM-dd HH:mm:ss",
        timeZone: TimeZone,
        locale: Locale,
        calendar: Calendar
    ) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.timeZone = timeZone
        formatter.dateFormat = format

        return formatter.string(from: self)
    }
}
