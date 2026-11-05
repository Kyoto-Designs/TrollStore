# WoopyStore

A SwiftUI rebrand concept for a trusted iOS app-library experience.

## What this starter contains

- A new WoopyStore visual identity: dark ink, mint, and rounded bold type
- Search, category filters, and app cards
- Responsive `GET` → progress → installed-state interaction
- A trust-forward product position: apps should be obtained through approved signing and distribution paths
- A `WoopyLogo` asset hook: add the logo you control to `Assets.xcassets` with that exact name; the UI will use it automatically.

## Bring it into Xcode

1. In Xcode, create a new **iOS App** named `WoopyStore` with the SwiftUI interface.
2. Replace the generated app source with `WoopyStoreApp.swift` and add `StoreView.swift`.
3. Add the logo asset you control as `WoopyLogo` in `Assets.xcassets` (the included fallback mark appears until then).
4. Set your own Bundle Identifier, team, icons, app metadata, and approved distribution configuration.

This is an interface starter. It deliberately does not include unsigned-IPA installation, signing-bypass, entitlement-bypass, or device-exploit functionality.
