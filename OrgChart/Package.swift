// swift-tools-version:5.2
import PackageDescription


let package = Package(
    name: "OrgChart",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "OrgChart",
            targets: ["OrgChart"]),
        .library(
            name: "ImageProcessor",
            targets: ["ImageProcessor"]),
    ],
    targets: [
        .target(
            name: "OrgChart",
            dependencies: []),
        .testTarget(
            name: "OrgChartTests",
            dependencies: ["OrgChart"]),
        .target(
            name: "ImageProcessor",
            dependencies: []),
        .testTarget(
            name: "ImageProcessorTests",
            dependencies: ["ImageProcessor"]),
    ]
)
