// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-semantic-version",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(name: "SwiftSemanticVersion", targets: ["SwiftSemanticVersion"])
    ],
    targets: [
        .target(
            name: "SwiftSemanticVersion",
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "SwiftSemanticVersionTests",
            dependencies: ["SwiftSemanticVersion"]
        )
    ],
    swiftLanguageModes: [.v5, .v6]
)

// MARK: - Utilities

func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

// MARK: - CI Pipeline

if hasEnvironmentVariable("GITHUB_ACTIONS") {
    for target in package.targets.filter(\.isTest) {
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
    }
}
