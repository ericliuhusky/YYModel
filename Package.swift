// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "YYModel",
    products: [
        .library(
            name: "YYModel",
            targets: ["YYModel"]),
    ],
    targets: [
        .target(
            name: "YYModel",
            dependencies: ["objc_msgSend"]),
        .target(name: "objc_msgSend")
    ]
)
