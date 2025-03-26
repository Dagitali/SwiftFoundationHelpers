//
//  URLExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 A test suite to validate the functionality of `URL` extensions.

 References:
 1. https://developer.apple.com/documentation/testing/migratingfromxctest
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Fixtures

private struct MockModel: Codable, Equatable {
    let id: Int
    let name: String
}

// MARK: - Test Suites

/// A test suite to validate the functionality of  `URL` extensions.
@Suite("URLExtensions Tests")
struct URLExtensionsTests {
    // MARK: JSON

    /// Tests the `decode()` instance method.
    ///
    /// This ensures the method correctly decodes the JSON file into the
    /// expected model.
    @Test
    func decode() {
        // Given...
        guard let testFileURL = Bundle.module.url(forResource: "example", withExtension: "json") else {
            Issue.record("Failed to locate test JSON file.")
            return
        }

        // When...
        let decodedModel: MockModel? = testFileURL.decode(as: MockModel.self)

        // Then...
        #expect(
            decodedModel != nil,
            "Decoded model should not be nil."
        )
        #expect(
            decodedModel == MockModel(id: 1, name: "Test Object"),
            "Decoded model does not match expected value."
        )
    }

    /// Tests the `encode()` instance method.
    ///
    /// This ensures the method correctly encodes the model into a JSON file.
    @Test
    func encode() {
        // Given...
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output.json")
        let modelToEncode = MockModel(id: 42, name: "Encoded Object")

        // When...
        outputURL.encode(modelToEncode)

        // Then...
        #expect(
            FileManager.default.fileExists(atPath: outputURL.path) == true,
            "Encoded file should exist."
        )

        // When...
        let decodedModel: MockModel? = outputURL.decode(as: MockModel.self)

        // THen...
        #expect(
            decodedModel == modelToEncode,
            "Decoded model should match the encoded model."
        )
    }

    // MARK: Queries

    /// Tests the `queryParameters` computed property.
    /// This ensures the property correctly returns a dictionary of query items
    /// parsed from the URL's query string.
    @Test()
    func queryParameters() {
        // Given...
        let url = URL(string: "https://example.com?foo=bar&baz=qux")!

        // When...
        let parameters = url.queryParameters

        // Then...
        #expect(
            parameters == ["foo": "bar", "baz": "qux"],
            "The queryParameters property should return the expected dictionary of query items."
        )
    }

    /// Tests the `appending()` instance  method.
    ///
    /// This ensures the method correctly adds or updates query parameters to
    /// the URL.
    @Test
    func appendingQueryParameters() {
        // Given...
        let baseURL = URL(string: "https://example.com")!

        // When...
        let newURL = baseURL.appending(queryParameters: ["key": "value"])

        // Then...
        #expect(newURL.absoluteString == "https://example.com?key=value")

        // Given...
        let existingURL = newURL

        // When...
        let updatedURL = existingURL.appending(queryParameters: ["new-key": "new-param"])

        // Then...
        #expect(
            updatedURL.absoluteString == "https://example.com?key=value&new-key=new-param" ||
            updatedURL.absoluteString == "https://example.com?foo=bar&new-key=new-param"
        )
    }

    /// Tests the `queryParameter()` instance  method.
    ///
    /// This ensures the method correctly retrieves the value of a query
    /// parameter from the URL.
    @Test(
        arguments: zip(
            ["key", "new-key"],
            ["value", "new-value"]
        )
    )
    func queryParameter(key: String, expected: String) {
        // Given...
        let url = URL(string: "https://example.com?key=value&new-key=new-value")!

        // When...
        let actual = url.queryParameter(for: key)

        // Then...
        #expect(
            actual == expected,
            """
            The query parameter value should be "\(expected)", not "\(actual)".
            """
        )
    }

    /// Tests the `queryParameter()` instance  method.
    ///
    /// This ensures the method correctly retrieves the value of a query
    /// parameter from the URL.
    @Test()
    func queryParameter_nil() {
        // Given...
        let url = URL(string: "https://example.com?key=value&new-key=new-param")!
        let expected: String? = nil

        // When...
        let actual = url.queryParameter(for: "missing")

        // Then...
        #expect(
            actual == expected,
            """
            The query parameter value should be "\(expected)", not "\(actual)".
            """
        )
    }

    // MARK: Schemes

    /// Tests the `isHTTP` computed property.
    ///
    /// This ensures the property correctly identifies URLs that use HTTP or
    /// HTTPS schemes.
    @Test(
        arguments: zip(
            [
                "https://example.com",
                "http://example.com",
                "ftp://example.com",
            ],
            [
                true, true, false
            ]
        )
    )
    func isHTTP(urlString: String, expected: Bool) {
        // Given...
        let url = URL(string: urlString)!

        // When...
        let actual = url.isHTTP

        // Then...
        #expect(
            actual == expected,
            """
            The URL's schema should \(expected ? "be" : "not be") of type "HTTPS" or "HTTP".
            """
        )
    }

    // MARK: Websites

    /// Tests the `favicon` computed property.
    /// This ensures the property correctly constructs the favicon's URL .
    @Test
    func favicon() {
        // Given...
        let homepage = "https://www.example.com"
        let expected = "\(homepage)/favicon.ico"
        let url = URL(string: expected)!

        // When...
        let actual = url.favicon

        // Then...
        #expect(
            actual?.absoluteString == expected,
            """
            The favicon URL should be "\(expected)".
            """
        )
    }

    /// Tests the `homepage` computed property.
    /// This ensures the property correctly constructs the homepage's URL .
    @Test
    func homepage() {
        // Given...
        let expected = "https://www.example.com"
        let url = URL(string: "\(expected)/path/to/somewhere")!

        // When...
        let actual = url.homepage

        // Then...
        #expect(
            actual?.absoluteString == expected,
            """
            The homepage URL should be "\(expected)".
            """
        )
    }
}
