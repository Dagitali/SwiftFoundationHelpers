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
    /// - Parameter key: The key of the query parameter.
    /// - Returns: The value of the query parameter as a string, or `nil` if it does not exist.
    func queryParameter(for key: String) -> String? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == key })?.value
    }
}
