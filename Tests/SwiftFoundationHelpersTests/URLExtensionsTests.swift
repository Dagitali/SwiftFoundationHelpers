//
//  URLExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `URL` extensions.
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `URL` extensions.
@Suite("URLExtensions Tests")
struct URLExtensionsTests {
    @Test
    func testQueryParameter() {
        let url = URL(string: "https://example.com?key=value&foo=bar")!
        #expect(url.queryParameter(for: "key") == "value")
        #expect(url.queryParameter(for: "foo") == "bar")
        #expect(url.queryParameter(for: "missing") == nil)
    }

    @Test
    func testAddingQueryParameters() {
        let baseURL = URL(string: "https://example.com")!
        let newURL = baseURL.addingQueryParameters(["key": "value", "foo": "bar"])
        #expect(newURL?.absoluteString == "https://example.com?key=value&foo=bar")

        let existingURL = URL(string: "https://example.com?existing=param")!
        let updatedURL = existingURL.addingQueryParameters(["new": "param"])
        #expect(updatedURL?.absoluteString == "https://example.com?existing=param&new=param")
    }
}
