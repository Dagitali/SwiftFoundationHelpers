//
//  StringExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `String` extensions.
*/

import Testing
@testable import SwiftFoundationHelpers

// MARK: - Mocks

enum Fruit: String, CaseIterable {
    case apple, banana, cherry
}

// MARK: - Test Suites

/// A test suite to validate the functionality of `String` extensions.
@Suite("StringExtensions Tests")
struct StringExtensionsTests {
    // MARK: Checks

    /// Tests the `contains()` method.
    ///
    /// This ensures it correctly checks if the string contains the specified
    /// substring.
    @Test(
        arguments: zip(
            [
                "world", // Case-sensitive
                "World"  // Case-insensitive
            ],
            [true, false]
        )
    )
    func contains(word: String, expected: Bool) {
        // Given...
        let string: String = "Hello, world!"

        // When...
        let actual = string.contains(word)

        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should contain the word "\(word)".
            """
        )
    }

    /// Tests the `isBlank()` method.
    ///
    /// This ensures it correctly checks if the string is empty or contains
    /// only whitespace characters.
    @Test(
        arguments: zip(
            [
                "",              // Empty string
                " ",             // Case-insensitive
                "\n\n",          // Multiple newlines

                String.empty,    // Empty string
                String.newline,  // Single newline
                // String.space,    // Single space    // FIXME: TBD

                "  Hello  ",     // Leading and trailing whitespace
                "\n\nworld\n\n", // Leading and trailing newlines

                String.dash      // Leading and trailing newlines
            ],
            [
                true, true, true,
                true, true,      // true,
                false, false,
                false
            ]
        )
    )
    func isBlank(string: String, expected: Bool) {
        // When...
        let actual = string.isBlank

        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should be blank.
            """
        )
    }

    /// Tests the `isNumeric()` method.
    ///
    /// This ensures it correctly checks if the string is numeric.
    @Test(
        arguments: zip(
            [
                "12345",    // Numeric

                "12345abc", // Alphanumeric
                ""          // Empty string
            ],
            [
                true,
                false, false
            ]
        )
    )
    func isNumeric(string: String, expected: Bool) {
        // When...
        let actual = string.isNumeric

        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should be numeric.
            """
        )
    }

    /// Tests the `matches()` method.
    ///
    /// This ensures it correctly checks if the string matches a given regular
    /// expression pattern.
    @Test(
        arguments: zip(
            [
                ("abc123", "\\w+\\d+"), // Starts with letters, ends with digits

                ("abc123", "^\\d+$"),   // Doesn't start with digits
                ("", ".+")              // Empty string
            ],
            [
                true,
                false, false
            ]
        )
    )
    func matches(strings: (main: String, pattern: String), expected: Bool) {
        // Given...
        let string = strings.main
        let pattern = strings.pattern

        // When...
        let actual = string.matches(pattern)

        // Then...
        #expect(
            actual == expected,
            """
            The pattern "\(pattern)" should match the string "\(string)".
            """
        )
    }

    // MARK: Matching

    /// Tests the `matchClosest()` method (array version).
    ///
    /// This ensures it correctly matches an array element.
    @Test(
        arguments: zip(
            ["appl", "banana", "xyz"],
            [true, true, false]
        )
    )
    func matchClosestInArray(string: String, expected: Bool) {
        // Given...
        let words = ["apple", "banana", "cherry"]

        // When...
        let actual = string.matchClosest(in: words)

        // Then...
        #expect(
            (actual != nil) == expected,
            """
            The closest match should be \(expected), not \(actual).
            """
        )
    }

    /// Tests the `matchClosest()` method (dictionary version).
    ///
    /// This ensures it correctly matches a dictionary key.
    @Test(
        arguments: zip(
            ["appl", "tabel", "xyz"],
            [true, true, false]
        )
    )
    func matchClosestInDictionary(string: String, expected: Bool) {
        // Given...
        let dictionary = ["apple": "fruit", "table": "furniture", "car": "vehicle"]

        // When...
        let actual = string.matchClosest(in: dictionary)

        // Then...
        #expect(
            (actual != nil) == expected,
            """
            The closest match should be \(expected), not \(actual).
            """
        )
    }

    /// Tests the `matchClosest()` method (`CaseIterable` enum version).
    ///
    /// This ensures it correctly matches an enum case.
    @Test(
        arguments: zip(
            ["appl", "bannana", "xyz"],
            [Fruit.apple, Fruit.banana, nil]
        )
    )
    func matchClosestInCaseIterable(string: String, expected: Fruit?) {
        // When...
        let actual = string.matchClosest(in: Fruit.self)

        // Then...
        #expect(
            actual == expected,
            """
            The closest match should be "\(expected)", not "\(actual)".
            """
        )
    }

    /// Tests the `levenshteinDistance()` method.
    ///
    /// This ensures it calculates the correct Levenshtein distance between 2
    /// strings.
    @Test(
        arguments: zip(
            [
                ("", "test"),
                ("apple", "apple"),
                ("flaw", "lawn"),
                ("kitten", "sitting"),
                ("test", "")
            ],
            [4, 0, 2, 3, 4]
        )
    )
    func levenshteinDistance(strings: (lhs: String, rhs: String), expected: Int) {
        // Given...
        let lhs = strings.lhs
        let rhs = strings.rhs

        // When...
        let actual = lhs.levenshteinDistance(to: rhs)

        // Then...
        #expect(
            actual == expected,
            """
            The Levenshtein distance should be \(expected), not \(actual).
            """
        )
    }

    // MARK: Transformation

    /// Tests the `removedWhitespace()` method.
    ///
    /// This ensures it correctly removed all whitespace and newlines from the
    /// string.
    @Test(
        arguments: zip(
            [
                " Hello \n World ", // Leading and trailing whitespace
                ""                  // Empty string
            ],
            ["HelloWorld", ""]
        )
    )
    func removedWhitespace(string: String, expected: String) {
        // When...
        let actual = string.removedWhitespace

        // Then...
        #expect(
            actual == expected,
            """
            The string with removed whitespace should be "\(expected)", not "\(actual)".
            """
        )
    }

    /// Tests the `reversedWords()` method.
    ///
    /// This ensures it correctly reversed the order of words in the string.
    @Test(
        arguments: zip(
            [
                "Swift Extensions are great", // Sentence
                ""                            // Empty string
            ],
            ["great are Extensions Swift", ""]
        )
    )
    func reversedWords(string: String, expected: String) {
        // When...
        let actual = string.reversedWords

        // Then...
        #expect(
            actual == expected,
            """
            The string with reversed words should be "\(expected)", not "\(actual)".
            """
        )
    }

    /// Tests the `trimmed()` method.
    ///
    /// This ensures it correctly trimmed leading and trailing whitespace and
    /// newline characters from the string.
    @Test(
        arguments: zip(
            [
                "  Hello  ",     // Leading and trailing whitespace
                "\n\nworld\n\n", // Leading and trailing newlines
                ""               // Empty string
            ],
            ["Hello", "world", ""]
        )
    )
    func trimmed(string: String, expected: String) {
        // When...
        let actual = string.trimmed

        // Then...
        #expect(
            actual == expected,
            """
            The trimmed string should be "\(expected)", not "\(actual)".
            """
        )
    }

    // MARK: Validation

    /// Tests the `isValidEmail()` method.
    ///
    /// This ensures it correctly validates whether the string is a properly
    /// formatted email address.
    @Test(
        arguments: zip(
            [
                "test@example.com",                  // Simple email
                "user.name+tag+sorting@example.com", // Email with special characters

                "plainaddress",                      // Missing @ symbol
                "missingdomain@.com",                // Missing domain
                "@missingusername.com"               // Missing username
            ],
            [
                true, true,
                false , false, false
            ]
        )
    )
    func isValidEmail(string: String, expected: Bool) {
        // When...
        let actual = string.isValidEmail
        
        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should be a valid email.
            """
        )
    }

    /// Tests the `isValidPassword()` method.
    ///
    /// This ensures it correctly validates whether the string is a strong
    /// password.
    @Test(
        arguments: zip(
            [
                "P@ssw0rd!",     // Strong password
                "Str0ng#Pass",   // Strong password w/ multiple special

                "weakpassword",  // No uppercase, no special character
                "SHORT1!",       // Less than 8 characters
                "NoNumber!",     // Missing number
                "NoSpecialChar1" // Missing special character
            ],
            [
                true, true,
                false , false, false, false
            ]
        )
    )
    func isValidPassword(string: String, expected: Bool) {
        // When...
        let actual = string.isValidPassword

        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should be a valid password.
            """
        )
    }

    /// Tests the `isValidPhone()` method.
    ///
    /// This ensures it correctly validates whether the string is a valid phone
    /// number.
    @Test(
        arguments: zip(
            [
                "0123456789", // Starts with 0
                "0987654321", // Random number

                "123456789",  // Does not start with 0
                "01234abc",   // Contains letters
                ""            // Empty string
            ],
            [
                true, true,
                false , false, false
            ]
        )
    )
    func isValidPhone(string: String, expected: Bool) {
        // When...
        let actual = string.isValidPhone

        // Then...
        #expect(
            actual == expected,
            """
            The string "\(string)" should be a valid phone number.
            """
        )
    }
}
