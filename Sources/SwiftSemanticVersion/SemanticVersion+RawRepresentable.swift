//
//  SemanticVersion+RawRepresentable.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension SemanticVersion: RawRepresentable {
    /// Parses a semantic version string, strictly adhering to SemVer specification.
    public init?(rawValue: String) {
        let rawString = rawValue.prefix(1).lowercased() == "v"
            ? String(rawValue.dropFirst())
            : rawValue

        let pattern = #"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$"#
        let groups = rawString.regexMatches(captureGroupsFromPattern: pattern)

        guard groups.count >= 4,
              let majString = groups[1], let maj = Int(majString),
              let minString = groups[2], let min = Int(minString),
              let patString = groups[3], let pat = Int(patString)
        else { return nil }

        major = maj
        minor = min
        patch = pat
        preRelease = if groups.count >= 5 {
            if let str = groups[4] { String(str) } else { nil }
        } else { nil }
        build = if groups.count >= 6 {
            if let str = groups[5] { String(str) } else { nil }
        } else { nil }

        guard major >= 0, minor >= 0, patch >= 0 else { return nil }
    }

    /// Returns the full version string.
    public var rawValue: String {
        let pre = preRelease == nil ? "" : "-" + preRelease!
        let bld = build == nil ? "" : "+" + build!
        return "\(major).\(minor).\(patch)\(pre)\(bld)"
    }
}

#endif
