// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "Guard",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15), .iOS(.v13),
    ],
    products: [
        .library(
            name: "Guard",
            targets: ["Guard"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Guard",
            path: "Guard/Guard"
        ),
        .testTarget(
            name: "GuardTests",
            dependencies: ["Guard"],
            path: "Guard/GuardTests"
        ),
    ]
)
