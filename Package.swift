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
  targets: [
    .target(
      name: "SwiftUIJSONRender"
    ),
    .testTarget(
      name: "SwiftUIJSONRenderTests",
      dependencies: ["SwiftUIJSONRender"]
    ),
  ]
)
