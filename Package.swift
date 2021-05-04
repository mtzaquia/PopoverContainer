// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopoverContainer",
	platforms: [
		.iOS(.v13)
	],
    products: [
        .library(
            name: "PopoverContainer",
            targets: ["PopoverContainer"]),
    ],
    targets: [
        .target(
            name: "PopoverContainer",
            dependencies: []),
    ]
)
