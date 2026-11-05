import SwiftUI

@main
struct WoopyStoreApp: App {
    @StateObject private var library = AppLibrary()

    var body: some Scene {
        WindowGroup {
            StoreView()
                .environmentObject(library)
                .tint(.woopyMint)
        }
    }
}

@MainActor
final class AppLibrary: ObservableObject {
    @Published var apps: [StoreApp] = StoreApp.sample
    @Published var selectedCategory: AppCategory = .all
    @Published var search = ""

    var filteredApps: [StoreApp] {
        apps.filter { app in
            (selectedCategory == .all || app.category == selectedCategory) &&
            (search.isEmpty || app.name.localizedCaseInsensitiveContains(search) || app.subtitle.localizedCaseInsensitiveContains(search))
        }
    }

    func install(_ app: StoreApp) {
        guard let index = apps.firstIndex(where: { $0.id == app.id }) else { return }
        apps[index].status = .installing
        Task {
            try? await Task.sleep(for: .seconds(1.2))
            apps[index].status = .installed
        }
    }
}

enum AppCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case games = "Games"
    case productivity = "Work"
    case utilities = "Utilities"
    var id: String { rawValue }
}

enum InstallStatus: Equatable {
    case ready, installing, installed
}

struct StoreApp: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let category: AppCategory
    let symbol: String
    let colors: [Color]
    var status: InstallStatus = .ready

    static let sample: [StoreApp] = [
        .init(name: "Pocket Notes", subtitle: "Notes that stay out of your way", category: .productivity, symbol: "note.text", colors: [.woopyMint, .woopyTeal]),
        .init(name: "Sora Weather", subtitle: "A calmer way to check the sky", category: .utilities, symbol: "cloud.sun.fill", colors: [.woopyBlue, .woopyIndigo]),
        .init(name: "Arcade Drift", subtitle: "Quick races. No clutter.", category: .games, symbol: "car.fill", colors: [.woopyCoral, .woopyOrange]),
        .init(name: "Daylight", subtitle: "Focus timer and daily rhythm", category: .productivity, symbol: "sun.max.fill", colors: [.woopyYellow, .woopyCoral]),
        .init(name: "Pixel Post", subtitle: "Tiny postcards for friends", category: .utilities, symbol: "photo.fill", colors: [.woopyPink, .woopyIndigo])
    ]
}

extension Color {
    static let woopyInk = Color(red: 0.06, green: 0.08, blue: 0.12)
    static let woopyMint = Color(red: 0.18, green: 0.91, blue: 0.69)
    static let woopyTeal = Color(red: 0.05, green: 0.61, blue: 0.62)
    static let woopyBlue = Color(red: 0.23, green: 0.51, blue: 1.00)
    static let woopyIndigo = Color(red: 0.38, green: 0.27, blue: 0.86)
    static let woopyCoral = Color(red: 1.00, green: 0.39, blue: 0.36)
    static let woopyOrange = Color(red: 1.00, green: 0.64, blue: 0.22)
    static let woopyYellow = Color(red: 1.00, green: 0.82, blue: 0.25)
    static let woopyPink = Color(red: 0.94, green: 0.30, blue: 0.65)
}
