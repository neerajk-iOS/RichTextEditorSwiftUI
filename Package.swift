// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RichTextEditorSwiftUI",
    platforms: [
           .iOS(.v15) // Adjust based on the minimum iOS version you want to support.
       ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RichTextEditorSwiftUI",
            targets: ["RichTextEditorSwiftUI"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RichTextEditorSwiftUI"),
        .testTarget(
            name: "RichTextEditorSwiftUITests",
            dependencies: ["RichTextEditorSwiftUI"]),
    ]
)
