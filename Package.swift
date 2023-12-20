// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "MKReminder",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MKReminder",
            targets: ["MKReminder"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "MKReminder",
            dependencies: [],
            path: "MKReminder"
        ),
    ]
)
