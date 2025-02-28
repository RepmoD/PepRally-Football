//
//  ContentView.swift
//  Gridiron
//
//  Created by David Brazeal on 2/24/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Use a more specific type name to avoid ambiguity
    @Query private var teamModels: [Item.TeamModel]
    // Alternatively, if models are defined in a different file:
    // @Query private var teamModels: [GridironModels.TeamModel]
    
    var body: some View {
        VStack {
            // Simple UI to verify build is working
            if teamModels.isEmpty {
                Text("No teams found")
                
                Button("Add Sample Team") {
                    addSampleTeam()
                }
                .buttonStyle(.bordered)
                .padding()
            } else {
                List(teamModels) { team in
                    Text(team.name)
                        .foregroundColor(team.primaryColor)
                }
            }
        }
        .padding()
    }
    
    private func addSampleTeam() {
        // Explicitly specify which TeamModel you're using
        let team = Item.TeamModel(
            name: "Sample Team",
            shortName: "TEAM",
            primaryColorHex: "0000FF",
            secondaryColorHex: "FFFFFF"
        )
        
        modelContext.insert(team)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Item.TeamModel.self, Item.PlayerModel.self,
                              Item.DriveModel.self, Item.PlayModel.self], inMemory: true)
}
