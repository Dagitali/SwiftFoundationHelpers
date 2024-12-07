//
//  StringExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `String` types.
*/

import Foundation

// MARK: - Public

public extension String {
    /// Determines whether the string matches a given regular expression pattern.
    ///
    /// - Parameter regex: A string containing the regular expression pattern.
    /// - Returns: A Boolean value indicating whether the string matches the pattern.
    func matches(_ regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }

    /// Trims leading and trailing whitespace and newline characters from the string.
    ///
    /// - Returns: A new string with whitespace and newline characters removed from both ends.
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
