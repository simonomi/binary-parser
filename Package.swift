// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "BinaryParser",
//    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "BinaryParser", targets: ["BinaryParser"]),
        .executable(name: "BinaryParserClient", targets: ["BinaryParserClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        .macro(
            name: "BinaryParserMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "BinaryParser", dependencies: ["BinaryParserMacros"]),
        .executableTarget(name: "BinaryParserClient", dependencies: ["BinaryParser"]),
        .testTarget(
            name: "BinaryParserTests",
            dependencies: [
                "BinaryParserMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ]
        )
    ]
)
