// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "DemoApp",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(name: "DemoApp", targets: ["DemoApp"]),
    ],
    targets: [
        .target(name: "DemoApp", path: "Sources/DemoApp"),
        .testTarget(name: "DemoAppTests", dependencies: ["DemoApp"], path: "Tests/DemoAppTests"),
    ]
)
