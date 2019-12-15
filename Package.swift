// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfLog",
    platforms: [
        .iOS(.v9), .macOS(.v10_13), .tvOS(.v11)
    ],
    products: [
        .library(
            name: "WolfLog",
            type: .dynamic,
            targets: ["WolfLog"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/ExtensibleEnumeratedName", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfStrings", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "WolfLog",
            dependencies: [
                "ExtensibleEnumeratedName",
                "WolfStrings"
        ])
        ]
)
