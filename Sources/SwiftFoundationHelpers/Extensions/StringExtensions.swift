//
//  StringExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with the `String` type.

 References:
 1. https://medium.com/stackademic/10-swift-extensions-i-use-all-the-time-a05bab1038bd
 */

import Foundation

// MARK: - Public

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
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
    @available(
        *,
        deprecated,
        message: "Use the standard library String.contains(_:) method instead."
    )
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
        let lhs = Array(self)
        let rhs = Array(other)

        guard !lhs.isEmpty else { return rhs.count }
        guard !rhs.isEmpty else { return lhs.count }

        let rows: [Character]
        let columns: [Character]
        if lhs.count >= rhs.count {
            rows = lhs
            columns = rhs
        } else {
            rows = rhs
            columns = lhs
        }

        var previousRow = Array(0...columns.count)
        var currentRow = Array(repeating: 0, count: columns.count + 1)

        for (rowIndex, rowCharacter) in rows.enumerated() {
            currentRow[0] = rowIndex + 1

            for (columnIndex, columnCharacter) in columns.enumerated() {
                let insertion = currentRow[columnIndex] + 1
                let deletion = previousRow[columnIndex + 1] + 1
                let substitution =
                    previousRow[columnIndex]
                    + (rowCharacter == columnCharacter ? 0 : 1)

                currentRow[columnIndex + 1] = Swift.min(
                    insertion,
                    deletion,
                    substitution
                )
            }

            swap(&previousRow, &currentRow)
        }

        return previousRow[columns.count]
    }

    /// Finds the closest match in an array of strings using the Levenshtein
    /// distance.
    /// - Parameter list: An array of strings to compare against. When multiple
    ///   values are equally close, the first value wins.
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
    @available(
        *,
        deprecated,
        message:
            "Use matchClosest(in:maximumDistance:) to supply the accepted edit distance explicitly."
    )
    func matchClosest(in list: [String]) -> String? {
        // Preserve the legacy edit-distance tolerance for source compatibility.
        // Adjust based on tolerance for spelling errors.
        matchClosest(in: list, maximumDistance: 2)
    }

    /// Finds the closest match in an array of strings using an explicit
    /// Levenshtein-distance limit.
    ///
    /// - Parameters:
    ///   - list: The strings to compare against. When multiple values are
    ///     equally close, the first value wins.
    ///   - maximumDistance: The greatest accepted edit distance. A negative
    ///     value accepts no matches.
    /// - Returns: The closest matching string within `maximumDistance`, or
    ///   `nil` when no value qualifies.
    func matchClosest(
        in list: [String],
        maximumDistance: Int
    ) -> String? {
        guard maximumDistance >= 0 else { return nil }

        var bestMatch: (word: String, distance: Int)?

        for word in list {
            let distance = self.levenshteinDistance(to: word)
            if distance <= maximumDistance,
                bestMatch.map({ distance < $0.distance }) ?? true
            {
                bestMatch = (word, distance)
            }
        }

        return bestMatch?.word
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
    @available(
        *,
        deprecated,
        message:
            "Use matchClosest(in:maximumDistance:) to supply the accepted edit distance explicitly."
    )
    func matchClosest<T>(in dictionary: [String: T]) -> T? {
        let keys = Array(dictionary.keys)
        guard
            let bestKey = matchClosest(
                in: keys,
                maximumDistance: 2
            )
        else { return nil }

        return dictionary[bestKey]
    }

    /// Finds the closest key in a dictionary using an explicit, deterministic
    /// matching policy.
    ///
    /// Dictionary keys are sorted before comparison, so the lexicographically
    /// first key wins when multiple keys have the same edit distance.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary whose string keys are compared.
    ///   - maximumDistance: The greatest accepted edit distance. A negative
    ///     value accepts no matches.
    /// - Returns: The value for the closest qualifying key, or `nil` when no
    ///   key qualifies.
    func matchClosest<T>(
        in dictionary: [String: T],
        maximumDistance: Int
    ) -> T? {
        let keys = dictionary.keys.sorted()
        guard
            let bestKey = matchClosest(
                in: keys,
                maximumDistance: maximumDistance
            )
        else { return nil }

        return dictionary[bestKey]
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
    @available(
        *,
        deprecated,
        message:
            "Use matchClosest(in:maximumDistance:) to supply the accepted edit distance explicitly."
    )
    func matchClosest<T: CaseIterable & RawRepresentable>(
        in enumType: T.Type
    ) -> T? where T.RawValue == String {
        let cases = enumType.allCases.map(\.rawValue)
        guard
            let bestRawValue = matchClosest(
                in: cases,
                maximumDistance: 2
            )
        else { return nil }

        return enumType.allCases.first { $0.rawValue == bestRawValue }
    }

    /// Finds the closest raw value in a `CaseIterable` string-backed enum
    /// using an explicit Levenshtein-distance limit.
    ///
    /// - Parameters:
    ///   - enumType: A case-iterable enum type with `String` raw values.
    ///   - maximumDistance: The greatest accepted edit distance. A negative
    ///     value accepts no matches.
    /// - Returns: The closest matching enum case, or `nil` when no case
    ///   qualifies.
    func matchClosest<T: CaseIterable & RawRepresentable>(
        in enumType: T.Type,
        maximumDistance: Int
    ) -> T? where T.RawValue == String {
        let cases = enumType.allCases.map { $0.rawValue }
        guard
            let bestRawValue = matchClosest(
                in: cases,
                maximumDistance: maximumDistance
            )
        else { return nil }

        return enumType.allCases.first { $0.rawValue == bestRawValue }
    }

    // MARK: Ordering

    /// Determines whether the string sorts before another string using
    /// localized standard ordering.
    ///
    /// Localized standard ordering compares embedded numbers naturally, so
    /// `"Route 2"` sorts before `"Route 10"`.
    ///
    /// - Parameter other: The string to compare against.
    /// - Returns: `true` when this string sorts before `other`.
    func isLocalizedStandardOrdered(before other: String) -> Bool {
        localizedStandardCompare(other) == .orderedAscending
    }

    // MARK: Transformation

    /// Returns the string after trimming surrounding whitespace and newlines,
    /// or `nil` when the trimmed result is empty.
    ///
    /// ## Example
    /// ```swift
    /// let name = "  Charlotte  ".trimmedNonEmpty
    /// print(name as Any)
    /// // Output: Optional("Charlotte")
    ///
    /// let blank = " \n ".trimmedNonEmpty
    /// print(blank as Any)
    /// // Output: nil
    /// ```
    var trimmedNonEmpty: String? {
        let trimmed = trimmed()
        return trimmed.isEmpty ? nil : trimmed
    }

    /// Normalizes the string by trimming all leading and trailing whitespace
    /// and newlines and converting all letters to lowercase.
    ///
    /// - Returns: A string with trimmed whitespace and newlines, converted to
    ///   lowercase.
    ///
    /// ## Example
    /// ```swift
    /// let text = " Hello World "
    /// print(text.normalized())
    /// // Output: "hello world"
    /// ```
    func normalized() -> String {
        trimmed().lowercased()
    }

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

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension Optional where Wrapped == String {
    /// Returns the wrapped string after trimming surrounding whitespace and
    /// newlines, or `nil` when the optional is missing or the trimmed result
    /// is empty.
    var trimmedNonEmpty: String? {
        flatMap(\.trimmedNonEmpty)
    }
}
