//
//  URLExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2024 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this sample’s licensing information.

 Abstract:
 Helper extensions for working with `URL` types.
*/

import Foundation

// MARK: - Public

public extension URL {
    /// Adds or updates query parameters to the URL.
    ///
    /// Example:
    /// ```swift
    /// if let url = URL(string: "https://example.com") {
    ///     let updatedURL = url.addingQueryParameters(["key": "value", "foo": "bar"])
    ///     print(updatedURL) // Output: "https://example.com?key=value&foo=bar"
    ///
    ///     let existingURL = URL(string: "https://example.com?existing=value")
    ///     let newURL = existingURL?.addingQueryParameters(["newKey": "newValue"])
    ///     print(newURL) // Output: "https://example.com?existing=value&newKey=newValue"
    /// }
    /// ```
    ///
    /// - Parameter parameters: A dictionary of query parameters to add or update.
    /// - Returns: A new URL with the updated query parameters.
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
    /// Example:
    /// ```swift
    /// if let url = URL(string: "https://example.com?key=value&foo=bar") {
    ///     print(url.queryParameter(for: "key")) // Output: "value"
    ///     print(url.queryParameter(for: "foo")) // Output: "bar"
    ///     print(url.queryParameter(for: "missing")) // Output: nil
    /// }
    /// ```
    ///
    /// - Parameter key: The key of the query parameter.
    /// - Returns: The value of the query parameter as a string, or `nil` if it does not exist.
    func queryParameter(for key: String) -> String? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)

        return components?.queryItems?.first(where: { $0.name == key })?.value
    }
}
