// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopoverContainer",
	platforms: [
		.iOS(.v14)
	],
    products: [
        .library(
            name: "PopoverContainer",
            targets: ["PopoverContainer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mtzaquia/UIKitPresentationModifier.git", branch: "main")
    ],
    targets: [
        .target(
            name: "PopoverContainer",
            dependencies: [
                "UIKitPresentationModifier"
            ]),
    ]
)
