//
//  GridironApp.swift
//  Gridiron
//
//  Created by David Brazeal on 2/24/25.
//

import SwiftUI
import SwiftData

@main
struct GridironApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Use explicit namespaces to avoid ambiguity
            Item.TeamModel.self,
            Item.PlayerModel.self,
            Item.DriveModel.self,
            Item.PlayModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
