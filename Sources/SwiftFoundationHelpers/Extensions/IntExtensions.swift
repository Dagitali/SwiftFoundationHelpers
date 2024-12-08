//
//  IntExtensions.swift
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
    /// - Returns: A `Range<Int>` from 0 to the integer.
    func range() -> Range<Int> {
        return 0..<self
    }

    /// Repeats a closure a specified number of times.
    ///
    /// - Parameter action: The closure to execute.
    func times(_ action: () -> Void) {
        for _ in range() {
            action()
        }
    }
}
