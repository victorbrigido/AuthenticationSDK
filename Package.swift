// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "AuthenticationSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AuthenticationSDK",
            targets: ["AuthenticationSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "AuthenticationSDK",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ]
        ),
        .testTarget(
            name: "AuthenticationSDKTests",
            dependencies: ["AuthenticationSDK"]
        ),
    ]
)

