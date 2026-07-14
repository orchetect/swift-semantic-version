//
//  SemanticVersion.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

/// Struct that represents a SemVer 2.0 version string into its components.
/// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
public struct SemanticVersion {
    /// Major version component. Must be `0` or greater. (ie: `x.2.4`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var major: Int {
        didSet {
            precondition(major >= 0)
            if major < 0 { major = oldValue }
        }
    }

    /// Minor version component. Must be `0` or greater. (ie: `1.x.4`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var minor: Int {
        didSet {
            precondition(minor >= 0)
            if minor < 0 { minor = oldValue }
        }
    }

    /// Patch version component. Must be `0` or greater. (ie: `1.2.x`)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting a value less than `0` causes a precondition failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var patch: Int {
        didSet {
            precondition(patch >= 0)
            if patch < 0 { patch = oldValue }
        }
    }

    /// Pre-release information. (Optional)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting an invalid string causes an assertion failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var preRelease: String? {
        didSet {
            guard let preRelease else { return }
            guard !preRelease.isEmpty else {
                self.preRelease = nil
                return
            }
            guard Self.isPreReleaseValid(preRelease) else {
                assertionFailure("Invalid pre-release string.")
                self.preRelease = oldValue
                return
            }
        }
    }

    /// Build metadata. (Optional)
    ///
    /// > Important:
    /// >
    /// > In debug builds, setting an invalid string causes an assertion failure.
    /// > In release builds, execution is not interrupted and the previous value is preserved silently.
    public var build: String? {
        didSet {
            guard let build else { return }
            guard !build.isEmpty else {
                self.build = nil
                return
            }
            guard Self.isBuildValid(build) else {
                assertionFailure("Invalid build string.")
                self.build = oldValue
                return
            }
        }
    }
}

extension SemanticVersion: Equatable { }

extension SemanticVersion: Hashable { }

extension SemanticVersion: Codable { }

extension SemanticVersion: Sendable { }

extension SemanticVersion: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

#endif
