// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "SwiftUIJSONRender",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
  ],
  products: [
    .library(
      name: "SwiftUIJSONRender",
      targets: ["SwiftUIJSONRender"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", exact: "0.10.0")
  ],
  targets: [
    .target(
      name: "SwiftUIJSONRender"
    ),
    .testTarget(
      name: "SwiftUIJSONRenderTests",
      dependencies: [
        "SwiftUIJSONRender",
        .product(name: "Testing", package: "swift-testing"),
      ]
    ),
  ]
)
