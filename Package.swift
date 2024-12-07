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
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "Interactions",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
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
