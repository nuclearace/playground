// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "playground",
    products: [
      .executable(name: "Runner", targets: ["Runner"]),
      .library(name: "Playground", targets: ["Playground"])
    ],
    dependencies: [
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.1.0"),
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.10.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Playground",
            dependencies: ["BigInt", "QDBMP", "CStuff"]),
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
