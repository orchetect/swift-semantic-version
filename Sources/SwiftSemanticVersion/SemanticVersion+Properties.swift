//
//  SemanticVersion+Properties.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Computed Metadata Properties

extension SemanticVersion {
    /// Returns `true` if the version is considered a stable release.
    public var isStable: Bool {
        preRelease == nil
    }

    /// Returns `true` if the version is considered a major release (ie: `2.0.0`).
    public var isMajorRelease: Bool {
        major > 0 && minor == 0 && patch == 0
    }

    /// Returns `true` if the version is considered a minor release (ie: `2.1.0`).
    public var isMinorRelease: Bool {
        minor > 0 && patch == 0
    }

    /// Returns `true` if the version is considered a patch release (ie: `2.1.3`).
    public var isPatchRelease: Bool {
        patch > 0
    }

    /// Returns `true` if the version is considered a pre-release.
    public var isPreRelease: Bool {
        preRelease != nil
    }

    /// Returns `true` if the version is considered the initial release.
    /// The only version that matches this criteria is `0.0.0`.
    public var isInitialRelease: Bool {
        isZero
    }

    /// Returns `true` if the version is zero without any pre-release or build metadata.
    /// The only version that matches this criteria is `0.0.0`.
    public var isZero: Bool {
        self == .zero
    }
}

#endif
