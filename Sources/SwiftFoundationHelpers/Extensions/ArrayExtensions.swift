//
//  ArrayExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `Array` types.
*/

import Foundation

// MARK: - Public

public extension Array where Element: Equatable {
    /// Removes duplicate elements from the array while preserving the original order.
    ///
    /// - Returns: A new array containing unique elements in the order they first appear.
    func removingDuplicates() -> [Element] {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
