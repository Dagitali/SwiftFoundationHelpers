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

 References:
 1. https://medium.com/stackademic/10-swift-extensions-i-use-all-the-time-a05bab1038bd
*/

import Foundation

// MARK: - Public

public extension String {
    // MARK: Comparison

    /// Determines whether the string matches a given regular expression pattern.
    ///
    /// - Parameter regex: A string containing the regular expression pattern.
    /// - Returns: A Boolean value indicating whether the string matches the pattern.
    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression) != nil
    }

    // MARK: Constants

    /// A constant for a dash character.
    static let dash = "-"

    /// A constant for an empty string.
    static let empty = ""

    /// A constant for a newline character.
    static let newline = "\n"

    /// A constant for a single space character.
    static let space = " "

    // MARK: Trimming

    /// Trims leading and trailing whitespace and newline characters from the string.
    ///
    /// - Returns: A new string with whitespace and newline characters removed from both ends.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: Validation

    /// Validates whether the string is a properly formatted email address.
    ///
    /// The email validation is based on the following pattern:
    /// - Starts with alphanumeric characters, including optional special characters.
    /// - Followed by an `@` symbol.
    /// - Ends with a valid domain name and top-level domain.
    ///
    /// - Returns: `true` if the string matches the email format; `false` if not.
    var isValidEmail: Bool {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }

    /// Validates whether the string is a strong password.
    ///
    /// A valid password must meet the following criteria:
    /// - Contains at least one uppercase letter.
    /// - Contains at least one lowercase letter.
    /// - Contains at least one numeric digit.
    /// - Contains at least one special character (`#?!@$%^&*-`).
    /// - Has a minimum length of 8 characters.
    ///
    /// - Returns: `true` if the string meets the password strength criteria; `false` if not.
    var isValidPassword: Bool {
        let regularExpression = "(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }

    /// Validates whether the string is a valid phone number.
    ///
    /// The phone number validation is based on the following pattern:
    /// - Starts with a `0`.
    /// - Followed by numeric characters only.
    ///
    /// - Returns: `true` if the string matches the phone number format; `false` if not.
    var isValidPhone: Bool {
        let regularExpression = "0[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }

    /// Checks if a string is empty or contains only whitespace characters.
    ///
    /// - Returns: `true` if the string is empty or contains only whitespace; `false` if not.
    func isEmptyOrWhitespace(_ regex: String) -> Bool {
        trimmed.isEmpty
    }
}
