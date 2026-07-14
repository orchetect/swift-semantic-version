//
//  SemanticVersion+Inits.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Additional Inits

extension SemanticVersion {
    /// Parses a semantic version string, strictly adhering to SemVer specification.
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    public init?(_ strict: String) {
        self.init(rawValue: strict)
    }

    /// Parses a semantic version string, using relaxed rules where `major` or `major.minor` version
    /// strings are accepted and any omitted trailing version components are assumed to be zero (`0`).
    public init?(nonStrict rawValue: String) {
        if let strict = Self(rawValue: rawValue) {
            self = strict
            return
        }

        let rawString = rawValue.prefix(1).lowercased() == "v"
            ? String(rawValue.dropFirst())
            : rawValue

        let pattern = #"^(0|[1-9]\d*)(\.(0|[1-9]\d*)){0,1}$"#
        let groups = rawString.regexMatches(captureGroupsFromPattern: pattern)

        guard groups.count >= 2,
              let majorVerString = groups[1],
              let majorVer = Int(majorVerString)
        else { return nil }

        major = majorVer
        minor = if groups.count >= 4 { Int(groups[3] ?? "") ?? 0 } else { 0 }
        patch = 0
        preRelease = nil
        build = nil

        guard major >= 0, minor >= 0, patch >= 0 else { return nil }
    }

    /// Initialize from individual version components.
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    ///
    /// - Parameters:
    ///   - major: Major version component. Must be `0` or greater. (Required)
    ///   - minor: Minor version component. Must be `0` or greater. (Required)
    ///   - patch: Patch version component. Must be `0` or greater. (Required)
    public init(
        _ major: UInt,
        _ minor: UInt,
        _ patch: UInt
    ) {
        self.major = Int(major)
        self.minor = Int(minor)
        self.patch = Int(patch)
    }

    /// Initialize from individual version components.
    ///
    /// - Parameters:
    ///   - major: Major version component. Must be `0` or greater. (Required)
    ///   - minor: Minor version component. Must be `0` or greater. (Required)
    ///   - patch: Patch version component. Must be `0` or greater. (Required)
    ///   - preRelease: Pre-release information. (Optional)
    ///   - build: Build metadata. (Optional)
    ///
    /// See [SemVer 2.0 Spec](https://semver.org/spec/v2.0.0.html).
    ///
    /// - Returns: This initializer will fail if either `major`, `minor`, or `patch` components are `< 0`.
    ///   This will also fail if `preRelease` or `build` are invalid strings.
    @_disfavoredOverload
    public init?<V: SignedInteger>(
        _ major: V,
        _ minor: V,
        _ patch: V,
        preRelease: String? = nil,
        build: String? = nil
    ) {
        guard major >= 0, minor >= 0, patch >= 0 else { return nil }

        self.init(UInt(major), UInt(minor), UInt(patch))

        if let preRelease, !preRelease.isEmpty {
            guard Self.isPreReleaseValid(preRelease) else { return nil }
            self.preRelease = preRelease
        } else {
            self.preRelease = nil
        }

        if let build, !build.isEmpty {
            guard Self.isBuildValid(build) else { return nil }
            self.build = build
        } else {
            self.build = nil
        }
    }
}

#endif
