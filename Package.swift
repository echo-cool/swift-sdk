// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LeanCloud",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "LeanCloud", targets: ["LeanCloud"]),
    ],
    dependencies: [
        .package(url: "https://github.com.cnpmjs.org/Alamofire/Alamofire.git", .upToNextMajor(from: "5.3.0")),
        .package(url: "https://github.com.cnpmjs.org/apple/swift-protobuf.git", .upToNextMajor(from: "1.13.0")),
        .package(url: "https://github.com.cnpmjs.org/apple/swift-nio-zlib-support.git", from: "1.0.0"),
        .package(url: "https://github.com.cnpmjs.org/groue/GRDB.swift.git", .upToNextMajor(from: "4.14.0"))
    ],
    targets: [
        .target(
            name: "LeanCloud",
            dependencies: [
                "Alamofire",
                "SwiftProtobuf",
                "GRDB"
            ],
            path: "Sources"
        )
    ],
    swiftLanguageVersions: [.v5]
)
