import SwiftUI

// Remove the @main attribute here since GridironApp.swift already has it
struct FootballStatsTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}

struct MainContentView: View {
    var body: some View {
        NavigationView {
            FootballStatTrackerView()
                .navigationTitle("Football Stats")
        }
    }
}
