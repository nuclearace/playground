// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "playground",
  platforms: [
    .macOS(.v12),
  ],
  products: [
    .executable(name: "Runner", targets: ["Runner"]),
    .executable(name: "Profiler", targets: ["Profiler"]),
    .executable(name: "Collatzing", targets: ["Collatzing"]),
    .library(name: "Playground", targets: ["Playground"])
  ],
  dependencies: [
    .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
    .package(url: "https://github.com/mkrd/Swift-BigInt", from: "2.1.0"),
    .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.12.0"),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-numerics", from: "0.0.2"),
    .package(url: "https://github.com/pvieito/PythonKit.git", .branch("master")),
    .package(url: "https://github.com/apple/swift-argument-parser", .branch("main")),
//        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0")
  ],
  targets: [
    .target(
      name: "Playground",
      dependencies: [
        "BigInt",
        "QDBMP",
        "CStuff",
        "CryptoSwift",
        .product(name: "Numerics", package: "swift-numerics"),
        .product(name: "BigNumber", package: "Swift-BigInt"),
                "PythonKit",
        "ClockTimer"
      ]),
    .executableTarget(
      name: "Profiler",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        "ClockTimer"
      ]
    ),
    .target(
      name: "ClockTimer"
    ),
    .target(name: "QDBMP"),
    .executableTarget(
      name: "Runner",
      dependencies: [
        "Playground",
        "CGMP",
        "BigInt",
        .product(name: "Numerics", package: "swift-numerics"),
        .product(name: "BigNumber", package: "Swift-BigInt"),
//              "PythonKit",
        "ClockTimer",
//              .product(name: "AsyncHTTPClient", package: "async-http-client"),
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ],
      /*swiftSettings: [.unsafeFlags(["-enforce-exclusivity=always"])],*/
      linkerSettings: [.unsafeFlags(["-L/usr/local/lib"])]
    ),
    .target(name: "CStuff"),
    .target(name: "Collatzing", dependencies: [
      "Playground",
      "BigInt",
      .product(name: "ArgumentParser", package: "swift-argument-parser"),
      "ClockTimer"
    ]),
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
