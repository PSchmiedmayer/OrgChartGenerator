// swift-tools-version:5.2

import PackageDescription


let package = Package(
    name: "OrgChartGenerator",
    platforms: [
        .macOS(.v10_15),
    ],
    dependencies: [
        .package(name: "SwiftPM", url: "https://github.com/apple/swift-package-manager.git", .exact("0.5.0")),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0-rc.1.2"),
    ],
    targets: [
        .target(
            name: "OrgChartGenerator",
            dependencies: [
                .product(name: "SPMUtility", package: "SwiftPM"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Leaf", package: "leaf")
            ]),
        .testTarget(
            name: "OrgChartGeneratorTests",
            dependencies: [
                .target(name: "OrgChartGenerator")
            ]),
    ]
)
