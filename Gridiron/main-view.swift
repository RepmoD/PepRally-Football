//
//  main-view.swift
//  Gridiron
//
//  Created by David Brazeal on 2/24/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var teams: [TeamModel]
    
    @State private var selectedTeam: TeamModel?
    @State private var isActiveDrive = false
    @State private var currentDrive: DriveModel?
    
    // Import the DriveResult enum from Item.swift to avoid ambiguity
    // We'll explicitly use the DriveResult from our model file
    
    var body: some View {
        VStack {
            // Team selector
            HStack(spacing: 16) {
                ForEach(teams) { team in
                    Button(action: {
                        selectedTeam = team
                    }) {
                        Text(team.shortName)
                            .font(.headline)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedTeam?.id == team.id ? team.primaryColor : Color(.systemGray5))
                            .foregroundColor(selectedTeam?.id == team.id ? .white : .primary)
                            .cornerRadius(8)
                    }
                    .disabled(isActiveDrive && selectedTeam?.id != team.id)
                }
                
                if teams.isEmpty {
                    Button(action: {
                        // Show team setup
                        showTeamSetup()
                    }) {
                        Text("Add Teams")
                            .font(.headline)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            
            // Break up complex expressions into simpler parts
            if let team = selectedTeam {
                if isActiveDrive, let drive = currentDrive {
                    // Active drive view
                    activeDriveView(for: team, drive: drive)
                } else {
                    // Team stats and drive history
                    teamStatsView(for: team)
                }
            } else {
                // No team selected yet
                noTeamSelectedView()
            }
        }
    }
    
    // Breaking down complex views into separate functions
    private func activeDriveView(for team: TeamModel, drive: DriveModel) -> some View {
        VStack {
            Text("Active Drive: \(drive.number)")
                .font(.headline)
            
            // Drive details would go here
            
            // End drive button
            Button("End Drive") {
                endDrive(with: "Punt") // Use string instead of enum directly
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    private func teamStatsView(for team: TeamModel) -> some View {
        VStack {
            Text(team.name)
                .font(.title)
            
            // Team stats would go here
            
            // New drive button
            Button("New Drive") {
                startNewDrive(for: team)
            }
            .padding()
            .background(team.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    private func noTeamSelectedView() -> some View {
        VStack {
            Text("Select a team to get started")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
        }
    }
    
    // Helper functions
    private func showTeamSetup() {
        // Show team setup logic
    }
    
    private func startNewDrive(for team: TeamModel) {
        let newDrive = DriveModel(
            number: 1,
            startYardLine: 25,
            startTime: Date()
        )
        newDrive.team = team
        
        modelContext.insert(newDrive)
        currentDrive = newDrive
        isActiveDrive = true
    }
    
    private func endDrive(with result: String) {
        guard let drive = currentDrive else { return }
        
        drive.endTime = Date()
        drive.result = result
        
        isActiveDrive = false
        currentDrive = nil
    }
}

#Preview {
    MainView()
        .modelContainer(for: [TeamModel.self, PlayerModel.self, DriveModel.self, PlayModel.self], inMemory: true)
}
