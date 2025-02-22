//
//  StringExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with `String` types.

 References:
 1. https://medium.com/stackademic/10-swift-extensions-i-use-all-the-time-a05bab1038bd
 */

import Foundation

// MARK: - Public

public extension String {
    // MARK: Checks

    /// Checks if the string is empty or contains only whitespace characters.
    ///
    /// - Returns: `true` if the string is empty or contains only whitespace;
    ///   `false` if not.
    ///
    /// ## Example
    /// ```swift
    /// let blankString = "\n\n"
    /// print(blankString.isBlank)
    /// // Output: true
    ///
    /// let nonBlankString = "  Hello  "
    /// print(nonBlankString.isBlank)
    /// // Output: false
    /// ```
    var isBlank: Bool {
        isEmpty || trimmed().isEmpty
    }

    /// Checks if the string contains only numeric characters.
    ///
    /// - Returns: `true` if the string is numeric; `false` if not.
    ///
    /// ## Example
    /// ```swift
    /// let numericString = "12345"
    /// print(numericString.isNumeric)
    /// // Output: true
    ///
    /// let nonNumericString = "123a45"
    /// print(nonNumericString.isNumeric)
    /// // Output: false
    /// ```
    var isNumeric: Bool {
        !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// Checks if the string contains the specified substring.
    ///
    /// - Parameter substring: The substring for which to search.
    /// - Returns: A Boolean value indicating whether the substring is found.
    ///
    /// ## Example
    /// ```swift
    /// let text = "Hello, world!"
    /// print(text.contains("world"))
    /// // Output: true
    /// print(text.contains("World"))
    /// // Output: false
    /// ```
    func contains(_ substring: String) -> Bool {
        range(of: substring) != nil
    }

    /// Checks if the string matches a given regular expression pattern.
    ///
    /// - Parameter regex: A string containing the regular expression pattern.
    /// - Returns: A Boolean value indicating whether the string matches the
    ///   pattern.
    ///
    /// ## Example
    /// ```swift
    /// let regex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    ///
    /// let email = "example@test.com"
    /// print(email.matches(regex))
    /// // Output: true
    ///
    /// let invalidEmail = "example@.com"
    /// print(invalidEmail.matches(regex))
    /// // Output: false
    /// ```
    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression) != nil
    }

    // MARK: Matching

    /// Finds the closest match in an array of strings using the Levenshtein
    /// distance.
    /// - Parameter list: An array of strings to compare against.
    /// - Returns: The closest matching string if found within the acceptable
    ///   distance.
    ///
    /// ## Example
    /// ```swift
    /// let words = ["apple", "table", "car"]
    /// let userInput = "appl"
    /// if let closestMatch = userInput.matchClosest(in: words) {
    ///     print("Did you mean: \(closestMatch)?")
    /// }
    /// ```
    func matchClosest(in list: [String]) -> String? {
        let maxDistance = 2  // Adjust based on tolerance for spelling errors
        var bestMatch: (String, Int)? = nil

        for word in list {
            let distance = self.levenshteinDistance(to: word)
            if distance <= maxDistance, (bestMatch == nil || distance < bestMatch!.1) {
                bestMatch = (word, distance)
            }
        }

        return bestMatch?.0
    }

    /// Finds the closest key match in a given dictionary using the Levenshtein
    /// distance.
    ///
    /// - Parameter dictionary: A dictionary where keys are strings to compare
    ///   against and values are associated data.
    /// - Returns: The value associated with the closest matching key, if found
    ///   within the acceptable distance.
    ///
    /// ## Example
    /// ```swift
    /// let dataDictionary = [
    ///     "apple": "fruit",
    ///     "table": "furniture",
    ///     "car": "vehicle"
    /// ]
    /// let userInput = "appl"
    /// if let closestMatch = userInput.matchClosest(in: dataDictionary) {
    ///     print("Did you mean: \(closestMatch)?")
    /// }
    /// ```
    func matchClosest<T>(in dictionary: [String: T]) -> T? {
        let keys = Array(dictionary.keys)
        if let bestKey = self.matchClosest(in: keys) {
            return dictionary[bestKey]
        }
        return nil
    }

    /// Finds the closest match in an enum that conforms to CaseIterable and
    /// has a String raw value.
    ///
    /// - Parameter enumType: A CaseIterable enum type where each case has a
    ///   String raw value.
    /// - Returns: The closest matching enum case if found within the
    ///   acceptable distance.
    ///
    /// Example:
    /// ```swift
    /// enum Fruit: String, CaseIterable {
    ///     case apple, banana, cherry
    /// }
    ///
    /// let userInput = "appl"
    /// if let closestMatch = userInput.matchClosest(in: Fruit.self) {
    ///     print("Did you mean: \(closestMatch.rawValue)?")
    /// }
    /// ```
    func matchClosest<T: CaseIterable & RawRepresentable>(in enumType: T.Type) -> T? where T.RawValue == String {
        let cases = enumType.allCases.map { $0.rawValue }
        if let bestRawValue = self.matchClosest(in: cases) {
            return enumType.allCases.first { $0.rawValue == bestRawValue }
        }
        return nil
    }

    /// Calculates the Levenshtein distance between the current string and
    /// another string.
    ///
    /// - Parameter other: The string to compare against.
    /// - Returns: The Levenshtein distance between the two strings.
    ///
    /// ## Example
    /// ```swift
    /// let distance = "kitten".levenshteinDistance(to: "sitting")
    /// print(distance)
    /// // Outputs: 3
    /// ```
    func levenshteinDistance(to other: String) -> Int {
        let lhsCount = self.count
        let rhsCount = other.count

        if lhsCount == 0 { return rhsCount }
        if rhsCount == 0 { return lhsCount }

        var matrix = Array(repeating: Array(repeating: 0, count: rhsCount + 1), count: lhsCount + 1)

        for i in 0...lhsCount { matrix[i][0] = i }
        for j in 0...rhsCount { matrix[0][j] = j }

        for i in 1...lhsCount {
            for j in 1...rhsCount {
                let cost = self[self.index(self.startIndex, offsetBy: i - 1)] ==
                           other[other.index(other.startIndex, offsetBy: j - 1)] ? 0 : 1
                matrix[i][j] = Swift.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
            }
        }

        return matrix[lhsCount][rhsCount]
    }

    // MARK: Transformation

    /// Removes all whitespace and newlines from the string.
    ///
    /// - Returns: A string with all whitespace and newlines removed.
    ///
    /// ## Example
    /// ```swift
    /// let text = " Hello \n World "
    /// print(text.removedWhitespace())
    /// // Output: "HelloWorld"
    /// ```
    func removedWhitespace() -> String {
        replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
    }

    /// Reverses the order of words in the string.
    ///
    /// - Returns: A string with the words reversed.
    ///
    /// ## Example
    /// ```swift
    /// let text = "Swift Extensions are great"
    /// print(text.reversedWords())
    /// // Output: "great are Extensions Swift"
    /// ```
    func reversedWords() -> String {
        split(separator: " ").reversed().joined(separator: " ")
    }

    /// Trims leading and trailing whitespace and newline characters from the
    /// string.
    ///
    /// - Returns: A new string with whitespace and newline characters removed
    ///   from both ends.
    ///
    /// ## Example
    /// ```swift
    /// let text = "   Hello, world!   "
    /// print(text.trimmed())
    /// // Output: "Hello, world!"
    /// ```
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: Validation

    /// Validates whether the string is a properly formatted email address.
    ///
    /// The email validation is based on the following pattern:
    /// - Starts with alphanumeric characters, including optional special
    ///   characters.
    /// - Followed by an `@` symbol.
    /// - Ends with a valid domain name and top-level domain.
    ///
    /// - Returns: `true` if the string matches the email format; `false` if
    ///   not.
    ///
    /// ## Example
    /// ```swift
    /// let email = "test@example.com"
    /// print(email.isValidEmail)
    /// // Output: true
    ///
    /// let invalidEmail = "example@.com"
    /// print(invalidEmail.isValidEmail)
    /// // Output: false
    /// ```
    var isValidEmail: Bool {
        wholeMatch(of: /^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,64}$/) != nil
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
    /// - Returns: `true` if the string meets the password strength criteria;
    ///  `false` if not.
    ///
    /// ## Example
    /// ```swift
    /// let password = "Str0ng#Pass"
    /// print(password.isValidPassword)
    /// // Output: true
    ///
    /// let weakPassword = "password"
    /// print(weakPassword.isValidPassword)
    /// // Output: false
    /// ```
    var isValidPassword: Bool {
        wholeMatch(of: /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}/) != nil
    }

    /// Validates whether the string is a valid phone number.
    ///
    /// The phone number validation is based on the following pattern:
    /// - Starts with a `0`.
    /// - Followed by numeric characters only.
    ///
    /// - Returns: `true` if the string matches the phone number format;
    /// ` false` if not.
    ///
    /// ## Example
    /// ```swift
    /// let phoneNumber = "0123456789"
    /// print(phoneNumber.isValidPhone)
    /// // Output: true
    ///
    /// let invalidPhoneNumber = "01234abc"
    /// print(invalidPhoneNumber.isValidPhone)
    /// // Output: false
    /// ```
    var isValidPhone: Bool {
        wholeMatch(of: /^0[0-9]+$/) != nil
    }
}
