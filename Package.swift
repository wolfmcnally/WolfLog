// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WolfLog",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfLog",
            targets: ["WolfLog"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "WolfLog",
            dependencies: ["WolfCore"])
        ]
)
