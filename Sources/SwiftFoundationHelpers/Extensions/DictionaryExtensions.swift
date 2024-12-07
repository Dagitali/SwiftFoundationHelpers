//
//  DictionaryExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `Dictionary` types.
*/

import Foundation

// MARK: - Public

public extension Dictionary {
    /// Merges the current dictionary with another dictionary.
    ///
    /// - Parameter other: The dictionary to merge into the current dictionary.
    /// - Returns: A new dictionary containing the combined key-value pairs.
    func merging(with other: Dictionary) -> Dictionary {
        return merging(other) { (_, new) in new }
    }

    /// Updates the current dictionary with the key-value pairs of another dictionary.
    ///
    /// - Parameter other: The dictionary to merge into the current dictionary.
    mutating func merge(with other: Dictionary) {
        other.forEach { self[$0.key] = $0.value }
    }
}
