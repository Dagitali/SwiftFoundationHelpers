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
    @Test
    func testContains() {
        #expect("Hello, world!".contains("world") == true) // Case-sensitive

        #expect("Hello, world!".contains("World") == false) // Case-insensitive
    }

    /// Tests the `isBlank()` method.
    ///
    /// This ensures it correctly checks if the string is empty or contains
    /// only whitespace characters.
    @Test
    func testIsBlank() {
        #expect("".isBlank == true) // Empty string
        #expect(" ".isBlank == true) // Single space
        #expect("\n\n".isBlank == true) // Multiple newlines

        #expect(String.empty.isBlank == true) // Empty string
        #expect(String.newline.isBlank == true) // Single newline
        #expect(String.space.isBlank == true) // Single space


        #expect("  Hello  ".isBlank == false) // Leading and trailing whitespace
        #expect("\n\nworld\n\n".isBlank == false) // Leading and trailing newlines

        #expect(String.dash.isBlank == false) // Leading and trailing newlines
    }

    /// Tests the `isNumeric()` method.
    ///
    /// This ensures it correctly checks if the string is numeric.
    @Test
    func testIsNumeric() {
        #expect("12345".isNumeric == true) // Empty string

        #expect("12345abc".isNumeric == false) // Leading and trailing whitespace
        #expect("".isNumeric == false) // Leading and trailing newlines
    }

    /// Tests the `isMatches()` method.
    ///
    /// This ensures it correctly checks if the string matches a given regular
    /// expression pattern.
    @Test
    func testMatches() {
        #expect("abc123".matches("\\w+\\d+") == true) // Starts with letters, ends with digits

        #expect("123abc".matches("^\\d+$") == false) // Doesn't start with digits
        #expect("".matches(".+") == false) // Empty string
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
    func testMatchClosestInArray(string: String, expected: Bool) {
        // Given...
        let words = ["apple", "banana", "cherry"]

        // When...
        let actual = string.matchClosest(in: words)

        // Then...
        #expect(
            (actual != nil) == expected,
            "The closest match should be \(expected), not \(actual)."
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
    func testMatchClosestInDictionary(string: String, expected: Bool) {
        // Given...
        let dictionary = ["apple": "fruit", "table": "furniture", "car": "vehicle"]

        // When...
        let actual = string.matchClosest(in: dictionary)

        // Then...
        #expect(
            (actual != nil) == expected,
            "The closest match should be \(expected), not \(actual)."
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
    func testMatchClosestInCaseIterable(string: String, expected: Fruit?) {
        // When...
        let actual = string.matchClosest(in: Fruit.self)

        // Then...
        #expect(
            actual == expected,
            "The closest match should be \(expected), not \(actual)."
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
    func testLevenshteinDistance(strings: (String, String), expected: Int) {
        // Given...
        let lhs = strings.0
        let rhs = strings.1

        // When...
        let actual = lhs.levenshteinDistance(to: rhs)

        // Then...
        #expect(
            actual == expected,
            "The Levenshtein distance should be \(expected), not \(actual)."
        )
    }

    // MARK: Transformation

    /// Tests the `removedWhitespace()` method.
    ///
    /// This ensures it correctly removed all whitespace and newlines from the
    /// string.
    @Test
    func testRemovedWhitespace() {
        #expect(" Hello \n World ".removedWhitespace == "HelloWorld")
        #expect("".removedWhitespace == "")
    }

    /// Tests the `reversedWords()` method.
    ///
    /// This ensures it correctly reversed the order of words in the string.
    @Test
    func testReversedWords() {
        #expect("Swift Extensions are great".reversedWords == "great are Extensions Swift")
        #expect("".reversedWords == "")
    }

    /// Tests the `trimmed()` method.
    ///
    /// This ensures it correctly trimmed leading and trailing whitespace and
    /// newline characters from the string.
    @Test
    func testTrimmed() {
        #expect("  Hello  ".trimmed == "Hello") // Leading and trailing whitespace
        #expect("\n\nworld\n\n".trimmed == "world") // Leading and trailing newlines
        #expect("".trimmed == "") // Empty string
    }

    // MARK: Validation

    /// Tests the `validEmail()` method.
    ///
    /// This ensures it correctly validates whether the string is a properly
    /// formatted email address.
    @Test
    func testIsValidEmail() {
        #expect("test@example.com".isValidEmail == true) // Simple email
        #expect("user.name+tag+sorting@example.com".isValidEmail == true) // Email with special characters

        #expect("plainaddress".isValidEmail == false) // Missing @ symbol.
        #expect("missingdomain@.com".isValidEmail == false) // Missing domain
        #expect("@missingusername.com".isValidEmail == false) // Missing username
    }

    /// Tests the `validPassword()` method.
    ///
    /// This ensures it correctly validates whether the string is a strong
    /// password.
    @Test
    func testIsValidPassword() {
        #expect("P@ssw0rd!".isValidPassword == true) // Strong password
        #expect("Str0ng#Pass".isValidPassword == true) // Strong password w/ multiple special characters

        #expect("weakpassword".isValidPassword == false) // No uppercase, no special character
        #expect("SHORT1!".isValidPassword == false) // Less than 8 characters
        #expect("NoNumber!".isValidPassword == false) // Missing number
        #expect("NoSpecialChar1".isValidPassword == false) // Missing special character
    }

    /// Tests the `validPassword()` method.
    ///
    /// This ensures it correctly validates whether the string is a valid phone
    /// number.
    @Test
    func testIsValidPhone() {
        #expect("0123456789".isValidPhone == true) // Starts with 0
        #expect("0987654321".isValidPhone == true) // Random number

        #expect("123456789".isValidPhone == false) // Does not start with 0
        #expect("01234abc".isValidPhone == false) // Contains letters
        #expect("".isValidPhone == false) // Empty string
    }
}
