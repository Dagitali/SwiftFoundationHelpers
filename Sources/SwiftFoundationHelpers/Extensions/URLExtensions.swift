//
//  URLExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with `URL` types.

 References:
 1. https://www.avanderlee.com/swift/url-components/
 2. https://matteomanferdini.com/swift-url-components/
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
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
    /// print(staticURL) // Prints: https://example.com/resource.json
    /// ```
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }

    // MARK: JSON

    /// Loads and decodes a JSON file at the URL into a specified `Decodable`
    /// type.
    ///
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
    /// let jsonURL = URL("file:///path/to/example.json")
    /// if let model: ExampleModel = jsonURL.decode(as: ExampleModel.self) {
    ///     print("Decoded Model:", model)
    /// }
    /// ```
    func decode<T: Decodable>(as type: T.Type) -> T? {
        guard let data = try? Data(contentsOf: self) else {
            print("Failed to load data from \(self).")
            return nil
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed to decode JSON from \(self): \(error)")
            return nil
        }
    }

    /// Encodes an `Encodable` object into JSON and writes it to the file at
    /// this URL.
    ///
    /// - Parameter object: The object conforming to `Encodable` to encode into
    ///   JSON.
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

    // MARK: Paths

    /// Appends a relative path component to the URL, ensuring it is valid.
    ///
    /// - Parameter component: The relative path component to append.
    /// - Returns: A new `URL` with the appended path, or `nil` if invalid.
    ///
    /// ## Example
    /// ```swift
    /// let baseURL = URL("https://example.com")
    /// if let newURL = baseURL.appendingSafePathComponent("path/to/resource") {
    ///     print(newURL) // Prints: https://example.com/path/to/resource
    /// }
    /// ```
    func appendingSafePathComponent(_ component: String) -> URL? {
        return appendingPathComponent(component, isDirectory: false)
    }

    // MARK: Queries

    /// Adds or updates query parameters to the URL.
    ///
    /// - Parameter parameters: A dictionary of query parameters to add or
    ///   update.
    /// - Returns: A new URL with the updated query parameters.
    ///
    /// ## Example
    /// ```swift
    /// if let url = URL(string: "https://example.com") {
    ///     let updatedURL = url.addingQueryParameters(
    ///         ["key": "value", "foo": "bar"]
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
    func addingQueryParameters(_ parameters: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        parameters.forEach { key, value in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components?.queryItems = queryItems

        return components?.url
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
}
