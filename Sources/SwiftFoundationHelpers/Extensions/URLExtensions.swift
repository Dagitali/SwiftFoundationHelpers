//
//  URLExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2026 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with the `URL` type.

 References:
 1. https://www.avanderlee.com/swift/url-components/
 2. https://matteomanferdini.com/swift-url-components/
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension URL {
    // MARK: Initialization

    /// Initializes a URL using a `StaticString`, ensuring compile-time safety.
    ///
    /// - Parameter string: A `StaticString` representing the URL.
    /// - Note: This initializer force-unwraps the URL, so use only with valid
    ///   static strings.
    ///
    /// ## Example
    /// ```swift
    /// let staticURL = URL("https://example.com/resource.json")
    /// print(staticURL)
    /// // Output: https://example.com/resource.json
    /// ```
    @available(
        *,
        deprecated,
        message: "Use init(validating:) to report invalid URLs instead of trapping."
    )
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }

    /// Initializes a URL by validating a string.
    ///
    /// - Parameter string: A string representing the URL.
    /// - Throws: `URLError.badURL` when Foundation cannot form a URL from the
    ///   supplied string.
    ///
    /// ## Example
    /// ```swift
    /// let url = try URL(validating: "https://example.com/resource.json")
    /// print(url)
    /// // Output: https://example.com/resource.json
    /// ```
    init(validating string: String) throws {
        guard
            let url = URL(
                string: string,
                encodingInvalidCharacters: false
            )
        else {
            throw URLError(.badURL)
        }

        self = url
    }

    // MARK: JSON

    /// Loads and decodes JSON from this URL.
    ///
    /// This source-compatible convenience preserves the original behavior: it
    /// uses a new `JSONDecoder`, reports failures to standard output, and
    /// returns `nil`. Use ``decode(as:using:)`` to receive errors and supply a
    /// configured decoder.
    ///
    /// - Parameter type: The type to decode.
    /// - Returns: The decoded value, or `nil` if loading or decoding fails.
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Decodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let jsonURL = URL("file:///path/to/example.json")
    /// if let model: ExampleModel = jsonURL.decode(as: ExampleModel.self) {
    ///     print("Decoded Model:", model)
    /// }
    /// ```
    @available(
        *,
        deprecated,
        message: "Use decode(as:using:) to preserve loading and decoding errors."
    )
    func decode<T: Decodable>(as type: T.Type) -> T? {
        guard let data = try? Data(contentsOf: self) else {
            print("Failed to load data from \(self).")
            return nil
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Failed to decode JSON from \(self): \(error)")
            return nil
        }
    }

    /// Loads and decodes JSON from this URL using a caller-supplied decoder.
    ///
    /// - Parameters:
    ///   - type: The type to decode.
    ///   - decoder: The decoder to use.
    /// - Returns: The decoded value.
    /// - Throws: The underlying loading or decoding error.
    func decode<T: Decodable>(
        as type: T.Type,
        using decoder: JSONDecoder
    ) throws -> T {
        let data = try Data(contentsOf: self)
        return try decoder.decode(type, from: data)
    }

    /// Encodes a value as JSON and writes it to this URL.
    ///
    /// This source-compatible convenience preserves the original behavior: it
    /// uses pretty-printed JSON, reports the result to standard output, and
    /// consumes encoding and writing errors. Use ``encode(_:using:options:)``
    /// to receive errors and supply explicit encoding policy.
    ///
    /// - Parameter object: The value to encode.
    ///
    /// ## Example
    /// ```swift
    /// struct ExampleModel: Encodable {
    ///     let id: Int
    ///     let name: String
    /// }
    ///
    /// let outputURL = URL("file:///path/to/output.json")
    /// let model = ExampleModel(id: 42, name: "Encoded Object")
    /// outputURL.encode(model)
    ///```
    @available(
        *,
        deprecated,
        message:
            "Use encode(_:using:options:) or encodeDeterministically(_:options:) to preserve errors and make encoding policy explicit."
    )
    func encode<T: Encodable>(_ object: T) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let data = try encoder.encode(object)
            try data.write(to: self)
            print("Successfully wrote JSON to \(self).")
        } catch {
            print("Failed to encode and write JSON to \(self): \(error)")
        }
    }

    /// Encodes a value with a caller-supplied encoder and writes it to this
    /// URL.
    ///
    /// - Parameters:
    ///   - object: The value to encode.
    ///   - encoder: The encoder that defines the JSON policy.
    ///   - options: Options used to write the encoded data.
    /// - Throws: The underlying encoding or file-writing error.
    func encode<T: Encodable>(
        _ object: T,
        using encoder: JSONEncoder,
        options: Data.WritingOptions = .atomic
    ) throws {
        let data = try encoder.encode(object)
        try data.write(to: self, options: options)
    }

    /// Encodes a value as deterministically ordered, pretty-printed JSON and
    /// writes it to this URL.
    ///
    /// - Parameters:
    ///   - object: The value to encode.
    ///   - options: Options used to write the encoded data.
    /// - Throws: The underlying encoding or file-writing error.
    func encodeDeterministically<T: Encodable>(
        _ object: T,
        options: Data.WritingOptions = .atomic
    ) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encode(object, using: encoder, options: options)
    }

    // MARK: Queries

    /// A dictionary representation of the URL's query parameters.
    ///
    /// This computed property parses the URL's query string using
    /// `URLComponents` and returns a dictionary where each key corresponds to
    /// a query item's name and its associated value is the query item's value.
    /// If the URL does not contain any query parameters or is invalid, an
    /// empty dictionary is returned.
    ///
    /// ## Example
    /// ```swift
    /// if let url = URL(string: "https://example.com?foo=bar&key=value") {
    ///     let parameters = url.queryParameters
    ///     print(parameters)
    ///     // Output: ["foo": "bar", "key": "value"]
    /// }
    /// ```
    var queryParameters: [String: String] {
        URLComponents(url: self, resolvingAgainstBaseURL: true)?
            .queryItems?
            .reduce(into: [String: String]()) { result, item in
                result[item.name] = item.value
            } ?? [:]
    }

    /// Adds or updates query parameters to the URL.
    ///
    /// - Parameter queryParameters: A dictionary of query parameters to add or
    ///   update.
    /// - Returns: A new URL with the updated query parameters.
    ///
    /// ## Example
    /// ```swift
    /// if let url = URL(string: "https://example.com") {
    ///     let updatedURL = url.appending(
    ///         queryParameters: ["key": "value", "foo": "bar"]
    ///     )
    ///     print(updatedURL)
    ///     // Output: "https://example.com?key=value&foo=bar"
    ///
    ///     let existingURL = URL(string: "https://example.com?existing=value")
    ///     let newURL = existingURL?.addingQueryParameters(["newKey": "newValue"])
    ///     print(newURL)
    ///     // Output: "https://example.com?existing=value&newKey=newValue"
    /// }
    /// ```
    @available(
        *,
        deprecated,
        message: "Use appending(queryParameters:sortingKeys:) to choose query ordering explicitly."
    )
    func appending(queryParameters: [String: String]) -> URL {
        let queryItems = queryParameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        return appending(queryItems: queryItems)
    }

    /// Adds or updates query parameters, optionally sorting them by key.
    ///
    /// - Parameters:
    ///   - queryParameters: The query parameters to add or update.
    ///   - sortingKeys: Whether to sort parameters lexicographically by key.
    /// - Returns: A new URL with the supplied query parameters.
    func appending(
        queryParameters: [String: String],
        sortingKeys: Bool
    ) -> URL {
        let parameters =
            sortingKeys
            ? queryParameters.sorted { $0.key < $1.key }
            : Array(queryParameters)
        let queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        return appending(queryItems: queryItems)
    }

    /// Retrieves the value of a query parameter from the URL.
    ///
    /// - Parameter key: The key of the query parameter.
    /// - Returns: The value of the query parameter as a string, or `nil` if it
    ///   does not exist.
    ///
    /// ## Example
    /// ```swift
    /// if let url = URL(string: "https://example.com?key=value&foo=bar") {
    ///     print(url.queryParameter(for: "key")) // Output: "value"
    ///     print(url.queryParameter(for: "foo")) // Output: "bar"
    ///     print(url.queryParameter(for: "missing")) // Output: nil
    /// }
    /// ```
    func queryParameter(for key: String) -> String? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)

        return components?.queryItems?.first(where: { $0.name == key })?.value
    }

    // MARK: Schemes

    /// A Boolean value indicating whether the URL uses an HTTP or HTTPS scheme.
    ///
    /// This computed property performs a case-insensitive check on the URL's
    /// scheme and returns `true` if the scheme is "http" or "https", and
    /// `false` if not.
    ///
    /// ## Example
    /// ```swift
    /// if let url = URL(string: "https://example.com") {
    ///     print(url.isHTTP)
    ///     // Output: true
    /// }
    /// if let url = URL(string: "ftp://example.com") {
    ///     print(url.isHTTP)
    ///     // Output: false
    /// }
    /// ```
    var isHTTP: Bool {
        guard let scheme = scheme?.lowercased() else { return false }

        return scheme == "http" || scheme == "https"
    }

    // MARK: Websites

    /// Constructs the favicon URL for the given website's URL, assuming that its favicon is located at the standard path `/favicon.ico`.
    ///
    /// - Returns: An optional URL representing the favicon location, or `nil` if the URL is not valid.
    /// - Note: Returns `nil` if the original URL does not contain a valid scheme or host.
    ///
    /// ## Example
    /// ```
    /// if
    ///     let url = URL(string: "https://www.example.com"),
    ///     let favicon = url.favicon {
    ///     print("Favicon URL: \(favicon)")
    ///     // Output: "https://example.com/favicon.ico"
    /// } else {
    ///     print("Invalid URL or missing favicon.")
    /// }
    ///
    /// ```
    var favicon: URL? {
        homepage?.appending(path: "favicon.ico")
    }

    /// Constructs the homepage URL for the given website's URL.
    ///
    /// - Returns: An optional URL representing the website location, or `nil` if the URL is not valid.
    /// - Note: Returns `nil` if the original URL does not contain a valid scheme or host.
    ///
    /// ## Example
    /// ```
    /// if
    ///     let url = URL(string: "https://www.example.com/path"),
    ///     let homepage = url.homepage {
    ///     print("Homepage URL: \(homepage)")
    ///     // Output: "https://example.com/"
    /// } else {
    ///     print("Invalid URL or missing homepage.")
    /// }
    ///
    /// ```
    var homepage: URL? {
        guard let scheme = self.scheme,
            let host = self.host
        else {
            return nil
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        return components.url
    }
}
