// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Windows)
let libType: Product.Library.LibraryType? = .dynamic
#else
let libType: Product.Library.LibraryType? = nil
#endif

let package = Package(
    name: "MapReduce",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MapReduce",
            type: libType,
            targets: ["MapReduce"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MapReduce"),
        .testTarget(
            name: "MapReduceTests",
            dependencies: ["MapReduce"]
        ),
    ]
)
