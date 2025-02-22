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
    
    /// Tests the `decode()` method.
    ///
    /// This ensures the method correctly decodes the JSON file into the
    /// expected model.
    @Test
    func testDecode() {
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
    
    /// Tests the `encode()` method.
    ///
    /// This ensures the method correctly encodes the model into a JSON file.
    @Test
    func testEncode() {
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
    
    /// Tests the `addingQueryParameters()` method.
    ///
    /// This ensures the method correctly adds or updates query parameters to
    /// the URL.
    @Test
    func testAddingQueryParameters() {
        // Given...
        let baseURL = URL(string: "https://example.com")!
        
        // When...
        let newURL = baseURL.addingQueryParameters(["key": "value"])
        
        // Then...
        #expect(newURL?.absoluteString == "https://example.com?key=value")
        
        // Given...
        let existingURL = newURL!
        
        // When...
        let updatedURL = existingURL.addingQueryParameters(["new-key": "new-param"])
        
        // Then...
        #expect(
            updatedURL?.absoluteString == "https://example.com?key=value&new-key=new-param" ||
            updatedURL?.absoluteString == "https://example.com?foo=bar&new-key=new-param"
        )
    }
    
    /// Tests the `queryParameter()` method.
    ///
    /// This ensures the method correctly retrieves the value of a query
    /// parameter from the URL.
    @Test(
        arguments: zip(
            ["key", "new-key"],
            ["value", "new-value"]
        )
    )
    func testQueryParameter(key: String, expected: String) {
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

    /// Tests the `queryParameter()` method.
    ///
    /// This ensures the method correctly retrieves the value of a query
    /// parameter from the URL.
    @Test()
    func testQueryParameter_nil() {
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
}
