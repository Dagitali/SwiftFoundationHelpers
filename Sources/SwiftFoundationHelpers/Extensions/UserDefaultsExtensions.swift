//
//  UserDefaultsExtensions.swift
//  SwiftFoundationHelpers
//
//  Copyright © 2025 Dagitali LLC. All rights reserved.
//

/*
 See the LICENSE.txt file for this package’s licensing information.

 Abstract:
 Helper extensions for working with the `UserDefaults` type.
*/

import Foundation

// MARK: - Public

@available(iOS 18.0, macCatalyst 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *)
public extension UserDefaults {
    // MARK: Keys

    /// A collection of keys used to store and retrieve values from
    /// `UserDefaults`.
    ///
    /// - Note: Use these keys to ensure consistency and avoid typos when
    ///   working with `UserDefaults`.
    struct Key {
        // App State
        public static let hasSeenOnboarding = "hasSeenOnboarding"
        public static let isFirstLaunch = "isFirstLaunch"
        public static let lastAppVersion = "lastAppVersion"
        public static let lastBuildNumber = "lastBuildNumber"
        public static let lastLaunchDate = "lastLaunchDate"
        public static let lastOpenedTab = "lastOpenedTab"
        public static let lastUpdateCheck = "lastUpdateCheck"
        public static let launchCount = "launchCount"
        public static let savedSearchFilters = "savedSearchFilters"

        // Feature Flags
        public static let enableAlphaFeatures = "enableAlphaFeatures"
        public static let enableBetaFeatures = "enableBetaFeatures"
        public static let enableDebugMode = "enableDebugMode"
        public static let enableDemoMode = "enableDemoMode"
        public static let enableTestingMode = "enableTestingMode"

        // User Authentication
        public static let isLoggedIn = "isLoggedIn"
        public static let lastLoginDate = "lastLoginDate"
        public static let sessionToken = "sessionToken"

        // User Preferences
        public static let appearanceMode = "appearanceMode"
        public static let autoLogin = "autoLogin"
        public static let browser = "browser"
        public static let language = "language"
        public static let notificationsEnabled = "notificationsEnabled"

        // User Profile
        public static let email = "email"
        public static let phoneNumber = "phoneNumber"
        public static let username = "username"
    }
}
