//
//  StringExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `String` extensions.
*/

import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `String` extensions.
@Suite("StringExtensions Tests")
struct StringExtensionsTests {
    // MARK: Checks

    /// Test for checking if the string the string contains the specified substring.
    @Test
    func testContains() {
        #expect("Hello, World!".contains("World") == true)   // Case-sensitive

        #expect("Hello, World!".contains("world") == false)  // Case-insensitive
    }

    /// Test for checking if the string if a string is empty or contains only whitespace characters.
    @Test
    func testIsEmptyOrWhitespace() {
        #expect("".isEmptyOrWhitespace == true)              // Empty string
        #expect(" ".isEmptyOrWhitespace == true)             // Single space
        #expect("\n\n".isEmptyOrWhitespace == true)          // Multiple newlines

        #expect(String.empty.isEmptyOrWhitespace == true)    // Empty string
        #expect(String.newline.isEmptyOrWhitespace == true)  // Single newline
        #expect(String.space.isEmptyOrWhitespace == true)    // Single space


        #expect("  hello  ".isEmptyOrWhitespace == false)      // Leading and trailing whitespace
        #expect("\n\nworld\n\n".isEmptyOrWhitespace == false)  // Leading and trailing newlines

        #expect(String.dash.isEmptyOrWhitespace == false)      // Leading and trailing newlines
    }

    /// Test for checking if the string if a string is empty or contains only whitespace characters.
    @Test
    func testIsNumeric() {
        #expect("".isEmptyOrWhitespace == true)              // Empty string

        #expect("  hello  ".isEmptyOrWhitespace == false)      // Leading and trailing whitespace
        #expect("\n\nworld\n\n".isEmptyOrWhitespace == false)  // Leading and trailing newlines
    }

    /// Test for checking if the string matches a given regular expression pattern.
    @Test
    func testMatches() {
        #expect("abc123".matches("\\w+\\d+") == true)  // Starts with letters, ends with digits

        #expect("123abc".matches("^\\d+$") == false)   // Doesn't start with digits
        #expect("".matches(".+") == false)             // Empty string
    }

    // MARK: Transformation

    /// Test for reversing the order of words in the string.
    @Test
    func testReversedWords() {
        #expect("Hello World".reversedWords == "World Hello")
        #expect("Swift Extensions are great".reversedWords == "great are Extensions Swift")
        #expect("".reversedWords == "")
    }

    /// Test for trimming leading and trailing whitespace and newline characters from the string.
    @Test
    func testTrimmed() {
        #expect("  hello  ".trimmed == "hello")      // Leading and trailing whitespace
        #expect("\n\nworld\n\n".trimmed == "world")  // Leading and trailing newlines
        #expect("".trimmed == "")                    // Empty string
    }

    // MARK: Validation

    /// Test for validating whether the string is a properly formatted email address.
    @Test
    func testIsValidEmail() {
        #expect("test@example.com".isValidEmail == true)                   // Simple email
        #expect("user.name+tag+sorting@example.com".isValidEmail == true)  // Email with special characters

        #expect("plainaddress".isValidEmail == false)          // Missing @ symbol.
        #expect("missingdomain@.com".isValidEmail == false)    // Missing domain
        #expect("@missingusername.com".isValidEmail == false)  // Missing username
    }

    /// Test for validating whether the string is a strong password.
    @Test
    func testIsValidPassword() {
        #expect("P@ssw0rd!".isValidPassword == true)    // Strong password
        #expect("Str0ng#Pass".isValidPassword == true)  // Strong password w/ multiple special characters

        #expect("weakpassword".isValidPassword == false)    // No uppercase, no special character
        #expect("SHORT1!".isValidPassword == false)         // Less than 8 characters
        #expect("NoNumber!".isValidPassword == false)       // Missing number
        #expect("NoSpecialChar1".isValidPassword == false)  // Missing special character
    }

    /// Test for validating whether the string is a valid phone number.
    @Test
    func testIsValidPhone() {
        #expect("0123456789".isValidPhone == true)  // Starts with 0
        #expect("0987654321".isValidPhone == true)  // Random number

        #expect("123456789".isValidPhone == false)  // Does not start with 0
        #expect("01234abc".isValidPhone == false)   // Contains letters
        #expect("".isValidPhone == false)           // Empty string
    }
}
