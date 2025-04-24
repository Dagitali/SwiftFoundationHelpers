//
//  URLExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with the `Bundle` type.

 References:
 1. https://www.avanderlee.com/swift/url-components/
 2. https://matteomanferdini.com/swift-url-components/
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension Bundle {
     // MARK: JSON

    /// Loads and decodes a JSON file from the bundle into a specified
    /// `Decodable` type.
    ///
    /// - Parameter file: The name of the JSON file (including extension) in
    ///   the bundle.
    /// - Parameter type: The type conforming to `Decodable` to decode the JSON
    ///   into.
    /// - Returns: An instance of the specified type, or `nil` if decoding
    ///   fails.
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// if let model: ExampleModel = Bundle.main.decode("example.json", as: ExampleModel.self) {
    ///     print("Decoded Model:", model)
    /// }
    /// ```
    func decode<T: Decodable>(_ file: String, as type: T.Type) -> T? {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            print("Failed to locate \(file) in bundle.")
            return nil
        }
        return url.decode(as: type)
    }

    /// Encodes an `Encodable` object into JSON and writes it to a file in the
    /// bundle.
    ///
    /// - Parameter object: The object conforming to `Encodable` to encode into
    ///   JSON.
    /// - Parameter file: The name of the JSON file to write (including
    ///   extension).
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let model = ExampleModel(id: 42, name: "Sample")
    /// Bundle.main.encode(model, to: "example.json")
    /// ```
    func encode<T: Encodable>(_ object: T, to file: String) {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            print("Failed to locate \(file) in bundle.")
            return
        }
        url.encode(object)
    }
}
