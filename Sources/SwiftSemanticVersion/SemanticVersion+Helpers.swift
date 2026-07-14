//
//  SemanticVersion+Helpers.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension SemanticVersion {
    /// Internal:
    /// Validates a pre-release component string.
    static func isPreReleaseValid(_ string: String) -> Bool {
        let pattern = #"^(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*$"#
        let matches = string.regexMatches(pattern: pattern)
        return matches.count == 1
    }

    /// Internal:
    /// Validates a build component string.
    static func isBuildValid(_ string: String) -> Bool {
        let pattern = #"^[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*$"#
        let matches = string.regexMatches(pattern: pattern)
        return matches.count == 1
    }
}

#endif
