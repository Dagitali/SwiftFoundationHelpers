//
//  BoolExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `Bool` types.
*/

import Foundation

// MARK: - Public

public extension Bool {
    /// Toggles the Boolean value.
    ///
    /// - Returns: The negated Boolean value.
    mutating func toggle() {
        self = !self
    }
}
