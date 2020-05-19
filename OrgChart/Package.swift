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
            name: "FaceCrop",
            targets: ["FaceCrop"]),
    ],
    targets: [
        .target(
            name: "OrgChart",
            dependencies: []),
        .testTarget(
            name: "OrgChartTests",
            dependencies: ["OrgChart"]),
        .target(
            name: "FaceCrop",
            dependencies: ["OrgChart"]),
        .testTarget(
            name: "FaceCropTests",
            dependencies: ["FaceCrop"]),
    ]
)
