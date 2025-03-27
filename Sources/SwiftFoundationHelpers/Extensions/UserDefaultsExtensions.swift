//
//  UserDefaultsExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with `UserDefaults` types.
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension UserDefaults {
    // MARK: Keys

    /// A collection of keys used to store and retrieve values from
    /// `UserDefaults`.
    ///
    /// - Note: Use these keys to ensure consistency and avoid typos when
    ///   working with `UserDefaults`.
    struct Key {
        // App State
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let isFirstLaunch = "isFirstLaunch"
        static let lastAppVersion = "lastAppVersion"
        static let lastBuildNumber = "lastBuildNumber"
        static let lastLaunchDate = "lastLaunchDate"
        static let lastOpenedTab = "lastOpenedTab"
        static let lastUpdateCheck = "lastUpdateCheck"
        static let launchCount = "launchCount"
        static let savedSearchFilters = "savedSearchFilters"

        // Feature Flags
        static let enableAlphaFeatures = "enableAlphaFeatures"
        static let enableBetaFeatures = "enableBetaFeatures"
        static let enableDebugMode = "enableDebugMode"
        static let enableDemoMode = "enableDemoMode"
        static let enableTestingMode = "enableTestingMode"

        // User Authentication
        static let isLoggedIn = "isLoggedIn"
        static let lastLoginDate = "lastLoginDate"
        static let sessionToken = "sessionToken"

        // User Preferences
        static let appearanceMode = "appearanceMode"
        static let autoLogin = "autoLogin"
        static let browser = "browser"
        static let language = "language"
        static let notificationsEnabled = "notificationsEnabled"

        // User Profile
        static let email = "email"
        static let phoneNumber = "phoneNumber"
        static let username = "username"
    }
}
