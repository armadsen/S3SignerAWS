// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "S3SignerAWS",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "S3SignerAWS", targets: ["S3SignerAWS"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "S3SignerAWS", dependencies: [], path: "Sources"),
        .testTarget(name: "S3SignerAWSTests", dependencies: ["S3SignerAWS"]),
    ]
)
