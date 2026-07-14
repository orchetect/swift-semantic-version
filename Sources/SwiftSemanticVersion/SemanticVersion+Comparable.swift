//
//  SemanticVersion+Comparable.swift
//  SwiftSemanticVersion • https://github.com/orchetect/swift-semantic-version
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation)

import Foundation

extension SemanticVersion: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        if lhs.patch != rhs.patch { return lhs.patch < rhs.patch }

        guard lhs.preRelease != rhs.preRelease else { return false }

        // One or both pre-release strings will be non-nil at this point.

        guard let lhsPreRelease = lhs.preRelease, let rhsPreRelease = rhs.preRelease else {
            // Only one pre-release string is non-nil. In that case, the non-pre-release takes precedence.
            return lhs.preRelease != nil
        }

        // Both pre-release strings are non-nil now, and we have determined they are not equal.

        // Pre-release strings must be compared by comparing each dot separated identifier from left
        // to right until a difference is found as follows:
        //     1. Identifiers consisting of only digits are compared numerically.
        //     2. Identifiers with letters or hyphens are compared lexically in ASCII sort order.
        //     3. Numeric identifiers always have lower precedence than non-numeric identifiers.
        //     4. A larger set of pre-release fields has a higher precedence than a smaller set, if all
        //        of the preceding identifiers are equal.

        let lhsIdentifiers = lhsPreRelease.split(separator: ".", omittingEmptySubsequences: false)
        let rhsIdentifiers = rhsPreRelease.split(separator: ".", omittingEmptySubsequences: false)

        var index = 0

        while lhsIdentifiers.indices.contains(index), rhsIdentifiers.indices.contains(index) {
            defer { index += 1 }
            let lhsID = lhsIdentifiers[index]
            let rhsID = rhsIdentifiers[index]

            if lhsID != rhsID {
                // first try numerical comparison if they are both integers
                if let lhsInt = Int(lhsID), let rhsInt = Int(rhsID) {
                    return lhsInt < rhsInt
                }
                // then try ASCII character ordering

                let lhsChars = lhsID.compactMap(\.asciiValue)
                assert(lhsChars.count == lhsID.count)

                let rhsChars = rhsID.compactMap(\.asciiValue)
                assert(rhsChars.count == rhsID.count)

                return lhsChars.lexicographicallyPrecedes(rhsChars)
            }
        }

        // at this point, one of the IDs may exist at the current index and the other does not.
        // (Technically it shouldn't be possible that both indexes don't exist, because that implies both
        // pre-release strings are equal, which we already checked for.)
        if lhsIdentifiers.indices.contains(index) { return false }
        if rhsIdentifiers.indices.contains(index) { return true }

        // We should never reach this point, because it implies that both pre-release strings are equal
        // (which we already checked for).
        return false

        // Note: SemVer spec specifies omitting build metadata from version precedence comparisons
    }
}

#endif
