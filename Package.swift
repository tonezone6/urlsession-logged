// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URLSessionLogged",
    products: [
        .library(
            name: "URLSessionLogged",
            targets: ["URLSessionLogged"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "URLSessionLogged",
            dependencies: []
        )
    ]
)
