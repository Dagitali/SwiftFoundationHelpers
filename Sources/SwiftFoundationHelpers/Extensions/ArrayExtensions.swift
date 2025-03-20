//
//  ArrayExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with `Array` types.
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension Array where Element: Equatable {
    /// Removes duplicate elements from the array while preserving the original order.
    ///
    /// - Returns: A new array containing unique elements in the order they first appear.
    ///
    /// ## Example
    /// ```swift
    /// let numbers = [1, 2, 2, 3]
    /// let uniqueNumbers = numbers.removingDuplicates()
    /// print(uniqueNumbers)
    /// // Output: [1, 2, 3]
    ///
    /// let words = ["a", "b", "b", "a"]
    /// let uniqueWords = words.removingDuplicates()
    /// print(uniqueWords)
    /// // Output: ["a", "b"]
    ///
    /// let empty = [String]()
    /// let uniqueEmpty = empty.removingDuplicates()
    /// print(uniqueEmpty)
    /// // Output: []
    /// ```
    func removingDuplicates() -> [Element] {
        reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
