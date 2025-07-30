// swift-tools-version:5.9
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.
import PackageDescription

let package = Package(
  name: "WeScan",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v17),
    .visionOS(.v1)
  ],
  products: [
    .library(name: "WeScan", targets: ["WeScan"])
  ],
  targets: [
    .target(name: "WeScan", resources: [.process("Resources")])
  ]
)
