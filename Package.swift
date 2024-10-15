// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Interactions",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library( // Das Framework, das extern importiert werden kann
            name: "Interactions", // Name des Frameworks
            targets: ["Interactions"]
        ),
    ],
    dependencies: [
        // Füge hier Abhängigkeiten hinzu, falls erforderlich
    ],
    targets: [
        .target(
            name: "Interactions", // Name des Framework-Targets
            dependencies: [], // Abhängigkeiten des Frameworks
            path: "Interactions"
        ),
        .testTarget(
            name: "InteractionsTests",
            dependencies: ["Interactions"]
        ),
        .executableTarget( // Demo-App
            name: "Interactions-sample-app",
            dependencies: ["Interactions"],
            path: "Interactions-sample-app"
        ),
    ]
)
