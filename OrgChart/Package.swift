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
        .library(
            name: "OrgChartRenderContext",
            targets: ["OrgChartRenderContext"]),
    ],
    targets: [
        .target(
            name: "OrgChart",
            dependencies: []),
        .testTarget(
            name: "OrgChartTests",
            dependencies: [
                .target(name: "OrgChart")
            ]),
        .target(
            name: "ImageProcessor",
            dependencies: []),
        .testTarget(
            name: "ImageProcessorTests",
            dependencies: [
                .target(name: "ImageProcessor")
            ]),
        .target(
            name: "OrgChartRenderContext",
            dependencies: [
                .target(name: "OrgChart"),
                .target(name: "ImageProcessor")
            ]),
        .testTarget(
            name: "OrgChartRenderContextTests",
            dependencies: [
                .target(name: "OrgChartRenderContext")
            ]),
    ]
)
