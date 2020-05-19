// swift-tools-version:5.2

import PackageDescription


let package = Package(
    name: "OrgChartGenerator",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .executable(name: "orgchartgenerator", targets: ["OrgChartGenerator"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.6"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0-rc.1.2"),
    ],
    targets: [
        .target(
            name: "OrgChartGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
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
