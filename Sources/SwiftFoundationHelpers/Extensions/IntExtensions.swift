//
//  IntExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with `Int` types.
*/

import Foundation

// MARK: - Public

public extension Int {
    /// Generates a range from 0 to the current integer (exclusive).
    ///
    /// - Returns: A `Range<Int>` from 0 to the integer.
    ///
    /// ## Example
    /// ```swift
    /// let range = 0.range
    /// print(range)
    /// // Output: 0..<0
    ///
    /// let range = 5.range
    /// print(range)
    /// // Output: 0..<5
    ///
    /// let array = Array(range)
    /// print(array)
    /// // Output: [0, 1, 2, 3, 4]
    /// ```
    var range: Range<Int> {
        0..<self
    }

    /// Repeats a closure a specified number of times.
    ///
    /// - Parameter action: The closure to execute.
    ///
    /// ## Example
    /// ```swift
    /// var sum = 0
    /// 3.times {
    ///     sum += 1
    /// }
    /// print(sum)
    /// // Output: 3
    /// ```
    func times(_ action: () -> Void) {
        for _ in range {
            action()
        }
    }
}
