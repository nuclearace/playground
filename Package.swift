// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "playground",
    products: [
        .executable(name: "Runner", targets: ["Runner"]),
        .executable(name: "Profiler", targets: ["Profiler"]),
        .library(name: "Playground", targets: ["Playground"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.1.0"),
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.10.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "Playground",
            dependencies: ["BigInt", "QDBMP", "CStuff", "CryptoSwift"]),
        .target(
            name: "Profiler"
        ),
        .target(name: "QDBMP"),
        .target(name: "Runner", dependencies: ["Playground", "CGMP", "BigInt"]),
        .target(name: "CStuff"),
        .systemLibrary(
            name: "CGMP",
            pkgConfig: "gmp",
            providers: [.brew(["gmp"])]
        ),
        .testTarget(
            name: "playgroundTests",
            dependencies: ["Playground", "SwiftCheck", "BigInt"]),
    ]
)
