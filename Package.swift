// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrgChartGenerator",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.5.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "OrgChartGenerator",
            dependencies: ["SPMUtility", "Vapor" ,"Leaf"]),
        .testTarget(
            name: "OrgChartGeneratorTests",
            dependencies: ["OrgChartGenerator"]),
    ]
)
