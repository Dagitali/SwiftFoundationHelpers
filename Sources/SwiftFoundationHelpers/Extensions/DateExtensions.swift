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
