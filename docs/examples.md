# Visual Examples

This gallery pairs the JSON examples with screenshots captured from Xcode previews. Screenshots will render once images are saved in `docs/images/`.

## How to Generate Screenshots (Xcode Previews)

### Automated (recommended)

Run the snapshot generator (macOS 13+). It renders the same JSON snippets as the previews using SwiftUI's `ImageRenderer`:

```
./scripts/generate-previews.sh
```

Use `--output` to target a custom directory:

```
./scripts/generate-previews.sh --output docs/images
```

### Manual (Xcode)

1. Open the package in Xcode.
2. Navigate to `Sources/SwiftUIJSONRender/PreviewSupport/ComponentPreviews.swift`.
3. Open the canvas (Editor → Canvas) and wait for previews to render.
4. Select the preview you want to capture.
5. Use **File → Export** or take a macOS screenshot for the selected preview.
6. Save images into `docs/images/` using the filenames below (`marketing-overview.png`, `form-flow.png`, `alerts-choices.png`, `financial-dashboard.png`).

## Composite Screenshots

| Scenario | Screenshot |
| --- | --- |
| Marketing overview | ![Marketing overview](images/marketing-overview.png) |
| Form flow | ![Form flow](images/form-flow.png) |
| Alerts and choices | ![Alerts and choices](images/alerts-choices.png) |
| Financial dashboard | ![Financial dashboard](images/financial-dashboard.png) |

These composites are defined in `Sources/PreviewSnapshotGenerator/main.swift` so you can update a single JSON tree per scenario. The generator renders each screenshot inside an iPhone 17-style frame. See `docs/json-to-ui.md` for full JSON → UI pairs.
