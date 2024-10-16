// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Interactions",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Interactions",
            targets: ["Interactions"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Interactions",
            dependencies: [],
            path: "Interactions"
        ),
        .testTarget(
            name: "InteractionsTests",
            dependencies: ["Interactions"]
        ),
        .executableTarget(
            name: "Interactions-sample-app",
            dependencies: ["Interactions"],
            path: "Interactions-sample-app"
        ),
    ]
)
