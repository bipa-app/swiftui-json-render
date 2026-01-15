import Foundation

/// Represents a semantic version for the JSON schema.
///
/// Follows semantic versioning (SemVer) with major.minor.patch format.
/// - Major: Breaking changes - old JSON may not render correctly
/// - Minor: New components/props added - fully backwards compatible
/// - Patch: Bug fixes only
public struct SchemaVersion: Sendable, Equatable, Hashable {
  public let major: Int
  public let minor: Int
  public let patch: Int

  /// The current schema version supported by this library.
  public static let current = SchemaVersion(1, 0, 0)

  /// The minimum schema version supported by this library.
  /// JSON with versions older than this may not render correctly.
  public static let minimumSupported = SchemaVersion(1, 0, 0)

  /// Creates a schema version from components.
  /// - Parameters:
  ///   - major: Major version number.
  ///   - minor: Minor version number.
  ///   - patch: Patch version number.
  public init(_ major: Int, _ minor: Int, _ patch: Int) {
    self.major = major
    self.minor = minor
    self.patch = patch
  }

  /// Parses a version string in "major.minor.patch" or "major.minor" format.
  /// - Parameter string: The version string to parse.
  /// - Returns: A `SchemaVersion` if parsing succeeds, `nil` otherwise.
  public init?(string: String) {
    let components = string.split(separator: ".").compactMap { Int($0) }
    guard components.count >= 2 else { return nil }

    self.major = components[0]
    self.minor = components[1]
    self.patch = components.count > 2 ? components[2] : 0
  }

  /// Returns the version as a string in "major.minor.patch" format.
  public var string: String {
    "\(major).\(minor).\(patch)"
  }
}

// MARK: - Comparison

extension SchemaVersion: Comparable {
  public static func < (lhs: SchemaVersion, rhs: SchemaVersion) -> Bool {
    if lhs.major != rhs.major { return lhs.major < rhs.major }
    if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
    return lhs.patch < rhs.patch
  }
}

// MARK: - Compatibility Checking

extension SchemaVersion {
  /// The result of checking version compatibility.
  public enum CompatibilityResult: Sendable, Equatable {
    /// The version is fully compatible.
    case compatible
    /// The version is from a newer minor/patch release. Rendering will proceed but some features may not be available.
    case newerMinor
    /// The version is from an older release but still within the support window.
    case olderSupported
    /// The version is too old and may not render correctly.
    case tooOld
    /// The version is from a newer major release and may not render correctly.
    case tooNew
  }

  /// Checks if a JSON schema version is compatible with this library.
  /// - Parameter jsonVersion: The version specified in the JSON.
  /// - Returns: The compatibility result.
  public static func checkCompatibility(of jsonVersion: SchemaVersion) -> CompatibilityResult {
    // Same major version
    if jsonVersion.major == current.major {
      if jsonVersion.minor > current.minor {
        // Newer minor version - may have unknown components/props
        return .newerMinor
      }
      return .compatible
    }

    // JSON is from a newer major version
    if jsonVersion.major > current.major {
      return .tooNew
    }

    // JSON is from an older major version
    if jsonVersion >= minimumSupported {
      return .olderSupported
    }

    return .tooOld
  }

  /// Checks if rendering should proceed for the given compatibility result.
  /// - Parameter result: The compatibility result.
  /// - Returns: `true` if rendering should proceed, `false` if it should fail.
  public static func shouldRender(for result: CompatibilityResult) -> Bool {
    switch result {
    case .compatible, .newerMinor, .olderSupported:
      return true
    case .tooOld, .tooNew:
      return false
    }
  }
}

// MARK: - Codable

extension SchemaVersion: Codable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let string = try container.decode(String.self)
    guard let version = SchemaVersion(string: string) else {
      throw DecodingError.dataCorruptedError(
        in: container,
        debugDescription: "Invalid version format: \(string)"
      )
    }
    self = version
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(string)
  }
}

// MARK: - CustomStringConvertible

extension SchemaVersion: CustomStringConvertible {
  public var description: String { string }
}
