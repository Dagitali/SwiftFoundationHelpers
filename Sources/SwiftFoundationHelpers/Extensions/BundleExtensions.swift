//
//  BundleExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
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

/// Errors produced while resolving resources in a bundle.
@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public enum BundleResourceError: Error, Equatable, Sendable {
    /// The requested resource does not exist in the bundle.
    case resourceNotFound(name: String, bundleIdentifier: String?)
}

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension Bundle {
     // MARK: JSON

    /// Loads and decodes a JSON file from the bundle into a specified
    /// `Decodable` type.
    ///
    /// - Parameter file: The name of the JSON file (including extension) in
    ///   the bundle.
    /// - Parameter type: The type conforming to `Decodable` to decode the JSON
    ///   into.
    /// - Returns: An instance of the specified type, or `nil` when the
    ///   resource cannot be loaded or decoded.
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// if let model = Bundle.main.decode("example.json", as: ExampleModel.self) {
    ///     print("Decoded Model:", model)
    /// }
    /// ```
    @available(
        *,
        deprecated,
        message: "Use decode(_:as:using:) to preserve loading and decoding errors."
    )
    func decode<T: Decodable>(_ file: String, as type: T.Type) -> T? {
        try? decode(file, as: type, using: JSONDecoder())
    }

    /// Loads and decodes a bundled JSON file using a caller-supplied decoder.
    ///
    /// - Parameters:
    ///   - file: The name of the JSON file, including its extension.
    ///   - type: The type to decode.
    ///   - decoder: The decoder to use.
    /// - Returns: An instance of the specified type.
    /// - Throws: ``BundleResourceError/resourceNotFound(name:bundleIdentifier:)``
    ///   when the resource is missing, or the underlying loading or decoding
    ///   error.
    func decode<T: Decodable>(
        _ file: String,
        as type: T.Type,
        using decoder: JSONDecoder
    ) throws -> T {
        guard let url = url(forResource: file, withExtension: nil) else {
            throw BundleResourceError.resourceNotFound(
                name: file,
                bundleIdentifier: bundleIdentifier
            )
        }

        return try url.decode(as: type, using: decoder)
    }

    /// Encodes an `Encodable` object into JSON and writes it to a file in the
    /// bundle.
    ///
    /// - Parameters:
    ///   - object: The object conforming to `Encodable` to encode into JSON.
    ///   - file: The name of the JSON file to write (including extension).
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let model = ExampleModel(id: 42, name: "Sample")
    /// writableBundle.encode(model, to: "example.json")
    /// ```
    ///
    /// - Important: Installed application bundles are normally read-only.
    ///   Prefer encoding to a writable file URL.
    @available(
        *,
        deprecated,
        message: "Application bundles are normally read-only; encode to a writable URL instead."
    )
    func encode<T: Encodable>(_ object: T, to file: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        try? encode(
            object,
            to: file,
            using: encoder,
            options: []
        )
    }

    /// Encodes an object to an existing bundled JSON file and propagates any
    /// encoding or writing failure.
    ///
    /// - Parameters:
    ///   - object: The object to encode.
    ///   - file: The name of the JSON file, including its extension.
    ///   - encoder: The encoder to use.
    ///   - options: Options used to write the encoded data.
    /// - Throws: ``BundleResourceError/resourceNotFound(name:bundleIdentifier:)``
    ///   when the resource is missing, or the underlying encoding or writing
    ///   error.
    /// - Important: Installed application bundles are normally read-only.
    ///   Prefer encoding to a writable file URL.
    @available(
        *,
        deprecated,
        message: "Application bundles are normally read-only; encode to a writable URL instead."
    )
    func encode<T: Encodable>(
        _ object: T,
        to file: String,
        using encoder: JSONEncoder,
        options: Data.WritingOptions = .atomic
    ) throws {
        guard let url = url(forResource: file, withExtension: nil) else {
            throw BundleResourceError.resourceNotFound(
                name: file,
                bundleIdentifier: bundleIdentifier
            )
        }

        try url.encode(object, using: encoder, options: options)
    }
}
