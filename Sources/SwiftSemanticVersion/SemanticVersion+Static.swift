//
//  SemanticVersion+Static.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

// MARK: - Static Constructors

extension SemanticVersion {
    /// Semantic version zero (`0.0.0`).
    public static let zero: SemanticVersion = .init(0, 0, 0)
}

#endif
