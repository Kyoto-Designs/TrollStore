import SwiftUI
import UIKit

struct StoreView: View {
    @EnvironmentObject private var library: AppLibrary

    var body: some View {
        NavigationStack {
            ZStack {
                Color.woopyInk.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 26) {
                        header
                        hero
                        categoryPicker
                        appGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 36)
                }
            }
            .searchable(text: $library.search, prompt: "Search apps")
            .preferredColorScheme(.dark)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            HStack(spacing: 11) {
                WoopyMark(size: 40)
                VStack(alignment: .leading, spacing: 1) {
                    Text("WoopyStore")
                        .font(.system(size: 25, weight: .black, design: .rounded))
                    Text("YOUR APP LIBRARY")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.52))
                }
            }
            Spacer()
            Text("DEMO")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(1)
                .foregroundStyle(.woopyMint)
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(.white.opacity(0.08), in: Capsule())
        }
        .padding(.top, 6)
    }

    private var hero: some View {
        ViewThatFits(in: .horizontal) {
            heroContent(compact: false)
            heroContent(compact: true)
        }
        .padding(22)
        .background(
            LinearGradient(colors: [.woopyIndigo, .woopyBlue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
    }

    @ViewBuilder
    private func heroContent(compact: Bool) -> some View {
        Group {
            if compact {
                VStack(alignment: .leading, spacing: 18) {
                    heroCopy
                    HStack {
                        Spacer()
                        WoopyMark(size: 72)
                    }
                }
            } else {
                HStack(spacing: 18) {
                    heroCopy
                    Spacer(minLength: 0)
                    WoopyMark(size: 86)
                        .rotationEffect(.degrees(8))
                }
            }
        }
    }

    private var heroCopy: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your space,\nyour apps.")
                .font(.system(.title, design: .rounded, weight: .heavy))
                .lineSpacing(-2)
                .fixedSize(horizontal: false, vertical: true)
            Text("Discover thoughtfully picked apps from sources you trust.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)
            Label("Interactive prototype — no downloads", systemImage: "info.circle.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(.woopyInk)
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
                .background(.woopyMint, in: Capsule())
        }
    }

    private var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browse")
                .font(.title3.weight(.bold))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 9) {
                    ForEach(AppCategory.allCases) { category in
                        Button(category.rawValue) { library.selectedCategory = category }
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(library.selectedCategory == category ? .woopyInk : .white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(library.selectedCategory == category ? .woopyMint : .white.opacity(0.09), in: Capsule())
                            .accessibilityLabel("\(category.rawValue) category")
                            .accessibilityValue(library.selectedCategory == category ? "Selected" : "Not selected")
                            .accessibilityAddTraits(library.selectedCategory == category ? .isSelected : [])
                            .buttonStyle(WoopyPressStyle())
                    }
                }
            }
        }
    }

    private var appGrid: some View {
        Group {
            if library.filteredApps.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.woopyMint)
                    Text("No matching apps")
                        .font(.headline.weight(.bold))
                    Text("Try a different name or category.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.64))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 42)
            } else {
                LazyVStack(spacing: 13) {
                    ForEach(library.filteredApps) { app in
                        AppCard(app: app) { library.install(app) }
                    }
                }
            }
        }
    }
}

private struct AppCard: View {
    let app: StoreApp
    let install: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            AppIcon(symbol: app.symbol, colors: app.colors)
            VStack(alignment: .leading, spacing: 4) {
                Text(app.name).font(.headline.weight(.bold))
                Text(app.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.60))
                    .lineLimit(1)
                Text(app.category.rawValue.uppercased())
                    .font(.system(size: 9, weight: .black, design: .rounded))
                    .tracking(0.8)
                    .foregroundStyle(.woopyMint)
            }
            Spacer(minLength: 8)
            Button(action: install) {
                switch app.status {
                case .ready: Text("GET")
                case .installing: ProgressView().tint(.woopyInk)
                case .installed: Image(systemName: "checkmark")
                }
            }
            .font(.caption.weight(.black))
            .foregroundStyle(.woopyInk)
            .frame(width: 64, height: 34)
            .background(app.status == .installed ? .woopyMint.opacity(0.65) : .woopyMint, in: Capsule())
            .disabled(app.status != .ready)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityHint("Demo only. This changes the card state and does not download an app.")
            .buttonStyle(WoopyPressStyle())
        }
        .padding(13)
        .background(.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 21, style: .continuous))
    }

    private var accessibilityLabel: String {
        switch app.status {
        case .ready: "Get \(app.name) demo"
        case .installing: "Installing \(app.name) demo"
        case .installed: "\(app.name) demo installed"
        }
    }
}

private struct WoopyPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.82 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

private struct AppIcon: View {
    let symbol: String
    let colors: [Color]
    var body: some View {
        Image(systemName: symbol)
            .font(.title2.weight(.bold))
            .foregroundStyle(.white)
            .frame(width: 58, height: 58)
            .background(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 17, style: .continuous))
    }
}

struct WoopyMark: View {
    let size: CGFloat
    var body: some View {
        Group {
            if let logo = UIImage(named: "WoopyLogo") {
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.31, style: .continuous)
                        .fill(LinearGradient(colors: [.woopyMint, .woopyTeal], startPoint: .topLeading, endPoint: .bottomTrailing))
                    Image(systemName: "wand.and.stars.inverse")
                        .font(.system(size: size * 0.47, weight: .black))
                        .foregroundStyle(.woopyInk)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.31, style: .continuous))
        .shadow(color: .woopyMint.opacity(0.3), radius: 12, y: 6)
    }
}

#Preview {
    StoreView().environmentObject(AppLibrary())
}
