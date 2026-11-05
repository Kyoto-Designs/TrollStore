# WoopyStore

A SwiftUI rebrand concept for a trusted iOS app-library experience. It targets iOS 16 and later.

## What this starter contains

- A new WoopyStore visual identity: dark ink, mint, and rounded bold type
- Search, category filters, and app cards
- Responsive, accessible demo `GET` → progress → installed-state interaction (no app is downloaded)
- A trust-forward product position: apps should be obtained through approved signing and distribution paths
- A `WoopyLogo` asset hook: add the logo you control to `Assets.xcassets` with that exact name; the UI will use it automatically.
- `index.html`: a self-contained, responsive browser preview with no build step or external dependencies.

## Preview the design

Open `index.html` in any modern browser. It includes live search, category filters, empty-search handling, keyboard-friendly buttons, and demo-only add states. It does not download, sign, or install software.

## Bring it into Xcode

1. In Xcode, create a new **iOS App** named `WoopyStore` with the SwiftUI interface and an iOS 16.0 deployment target.
2. Replace the generated app source with `WoopyStoreApp.swift` and add `StoreView.swift`.
3. Add the logo asset you control as `WoopyLogo` in `Assets.xcassets` (the included fallback mark appears until then).
4. Set your own Bundle Identifier, team, icons, app metadata, and approved distribution configuration.

This is an interface starter. It deliberately does not include unsigned-IPA installation, signing-bypass, entitlement-bypass, or device-exploit functionality.
