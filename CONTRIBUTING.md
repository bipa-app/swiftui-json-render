# Contributing to SwiftUI JSON Render

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing.

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

If you discover a security issue, please follow the guidance in [SECURITY.md](SECURITY.md) instead of opening a public issue.

## How to Contribute

### Reporting Bugs

Before creating a bug report, please check existing issues to avoid duplicates. When creating a bug report, include:

- A clear, descriptive title
- Steps to reproduce the issue
- Expected vs actual behavior
- Your environment (iOS/macOS version, Xcode version, Swift version)
- Relevant JSON and code snippets

### Suggesting Features

Feature requests are welcome! Please include:

- A clear description of the feature
- The problem it solves or use case it enables
- Example JSON schema if proposing a new component

### Pull Requests

1. Fork the repository
2. Create a feature branch from `main`
3. Make your changes
4. Ensure tests pass
5. Submit a pull request

## Development Setup

### Requirements

- Xcode 15.0+
- Swift 5.9+
- macOS 13+ (for development)

### Building

```bash
# Clone the repository
git clone https://github.com/bipa-app/swiftui-json-render.git
cd swiftui-json-render

# Build
swift build

# Run tests
swift test
```

### Project Structure

```
Sources/SwiftUIJSONRender/
├── Core/                 # Core types (JSONView, RenderContext, ComponentNode)
├── Components/           # Built-in component builders
│   ├── Content/          # Text, Heading, Image, Icon
│   ├── Interactive/      # Button, AmountInput, ChoiceList, ConfirmDialog
│   ├── Layout/           # Stack, Card, Divider, Spacer
│   ├── Feedback/         # Alert
│   └── Financial/        # BalanceCard, TransactionRow, Charts
├── Theme/                # Theming protocols and defaults
├── Strings/              # Localization protocols
├── Environment/          # SwiftUI environment keys
├── Streaming/            # Streaming JSON parser and renderer
├── Utilities/            # Color parsing, financial formatting
└── Validation/           # JSON validation
```

## Coding Guidelines

### Swift Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful names that describe purpose
- Keep functions focused and small

### SwiftUI Best Practices

- Use modern SwiftUI APIs:
  - `.foregroundStyle()` instead of `.foregroundColor()`
  - `.clipShape(.rect(cornerRadius:))` instead of `.cornerRadius()`
- Use theme properties from `RenderContext` instead of hardcoded values
- Use strings from `RenderContext` for user-facing text

### Component Guidelines

When creating new components:

1. Create a builder conforming to `ComponentBuilder`
2. Use `RenderContext` for theming and strings
3. Document props in the header comment
4. Add tests in `Tests/SwiftUIJSONRenderTests/Components/`

Example:

```swift
/// Renders a Badge component.
///
/// ## JSON Example
/// ```json
/// {
///   "type": "Badge",
///   "props": {
///     "text": "New",
///     "color": "#FF0000"
///   }
/// }
/// ```
///
/// ## Props
/// - `text`: Badge text (required)
/// - `color`: Background color (optional)
public struct BadgeBuilder: ComponentBuilder {
    public static var typeName: String { "Badge" }

    @MainActor
    public static func build(node: ComponentNode, context: RenderContext) -> AnyView {
        // Implementation using context for theming
    }
}
```

### Testing

- Write tests for new components and features
- Use Swift Testing framework (`@Suite`, `@Test`, `#expect`)
- Test both success and edge cases

### Commit Messages

- Use clear, descriptive commit messages
- Start with a verb (Add, Fix, Update, Remove)
- Reference issues when applicable

Examples:
- `Add Badge component with color customization`
- `Fix Button disabled state opacity`
- `Update README with new theming properties`

## Review Process

1. All PRs require at least one review
2. CI must pass (build + tests)
3. Documentation must be updated if applicable
4. CHANGELOG.md should be updated for user-facing changes

## Questions?

Feel free to open an issue for questions or discussions about contributing.
