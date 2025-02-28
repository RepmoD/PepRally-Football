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
    
    // Use direct type name without namespace
    @Query private var teams: [TeamModel]
    
    var body: some View {
        VStack {
            // Simple UI to verify build is working
            if teams.isEmpty {
                Text("No teams found")
                
                Button("Add Sample Team") {
                    addSampleTeam()
                }
                .buttonStyle(.bordered)
                .padding()
            } else {
                List(teams) { team in
                    Text(team.name)
                        .foregroundColor(team.primaryColor)
                }
            }
        }
        .padding()
    }
    
    private func addSampleTeam() {
        // Direct reference to TeamModel
        let team = TeamModel(
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
        .modelContainer(for: [TeamModel.self, PlayerModel.self,
                              DriveModel.self, PlayModel.self], inMemory: true)
}
