//
//  DictionaryExtensionsTests.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 A test suite to validate the functionality of `Dictionary` extensions.
*/

import Foundation
import Testing
@testable import SwiftFoundationHelpers

// MARK: - Test Suites

/// A test suite to validate the functionality of  `Dictionary` extensions.
@Suite("DictionaryExtensions Tests")
struct DictionaryExtensionsTests {
    /// Test for updating the current dictionary with the key-value pairs of another dictionary.
    @Test
    func testMerge() {
        var dict = ["a": 1, "b": 2]
        let dictToMerge = ["b": 3, "c": 4]
        dict.merge(with: dictToMerge)
        #expect(dict == ["a": 1, "b": 3, "c": 4])
    }

    /// Test for merging the current dictionary with another dictionary.
    @Test
    func testMerging() {
        let dict1 = ["a": 1, "b": 2]
        let dict2 = ["b": 3, "c": 4]
        #expect(dict1.merging(with: dict2) == ["a": 1, "b": 3, "c": 4])
    }
}
