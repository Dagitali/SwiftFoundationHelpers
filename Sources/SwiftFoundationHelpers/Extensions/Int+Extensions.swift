//
//  Int+Extensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `Int` types.
*/

import Foundation

// MARK: - Public

public extension Int {
    /// Generates a range from 0 to the current integer (exclusive).
    ///
    /// Example:
    /// ```swift
    /// let range = 0.range
    /// print(range) // Output: 0..<0
    ///
    /// let range = 5.range
    /// print(range) // Output: 0..<5
    ///
    /// let array = Array(range)
    /// print(array) // Output: [0, 1, 2, 3, 4]
    /// ```
    ///
    /// - Returns: A `Range<Int>` from 0 to the integer.
    var range: Range<Int> {
        0..<self
    }

    /// Repeats a closure a specified number of times.
    ///
    /// Example:
    /// ```swift
    /// var sum = 0
    /// 3.times {
    ///     sum += 1
    /// }
    /// print(sum) // Output: 3
    /// ```
    ///
    /// - Parameter action: The closure to execute.
    func times(_ action: () -> Void) {
        for _ in range {
            action()
        }
    }
}
