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
    /// print(staticURL)
    /// // Output: https://example.com/resource.json
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
    /// - Parameter parameters: A dictionary of query parameters to add or
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
    func appending(queryParameters: [String: String]) -> URL {
        let queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }

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
              let host = self.host else {
            return nil
        }

        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        return components.url
    }
}
