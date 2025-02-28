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
    @Query private var teams: [TeamModel]
    @State private var showNewTeamSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                if teams.isEmpty {
                    VStack(spacing: 20) {
                        Text("Welcome to Gridiron")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("No teams found. Add a team to get started.")
                            .foregroundColor(.secondary)
                        
                        Button("Add Sample Teams") {
                            addSampleTeams()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(teams) { team in
                            NavigationLink(destination: TeamDetailView(team: team)) {
                                TeamRow(team: team)
                            }
                        }
                        .onDelete(perform: deleteTeams)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                            Button(action: { showNewTeamSheet = true }) {
                                Label("Add Team", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Teams")
            .sheet(isPresented: $showNewTeamSheet) {
                NewTeamView()
            }
        }
    }
    
    private func addSampleTeams() {
        // Add Home Team
        let homeTeam = TeamModel(
            name: "Home Team",
            shortName: "HOME",
            primaryColorHex: "0000FF",  // Blue
            secondaryColorHex: "FFFFFF" // White
        )
        
        // Add Away Team
        let awayTeam = TeamModel(
            name: "Away Team",
            shortName: "AWAY",
            primaryColorHex: "FF0000",  // Red
            secondaryColorHex: "FFFFFF" // White
        )
        
        // Add sample players to home team
        let homeQB = PlayerModel(number: 12, name: "Tom Brady", position: "QB")
        homeQB.team = homeTeam
        homeTeam.players.append(homeQB)
        
        let homeRB = PlayerModel(number: 22, name: "Emmitt Smith", position: "RB")
        homeRB.team = homeTeam
        homeTeam.players.append(homeRB)
        
        let homeWR = PlayerModel(number: 80, name: "Jerry Rice", position: "WR")
        homeWR.team = homeTeam
        homeTeam.players.append(homeWR)
        
        // Add sample players to away team
        let awayQB = PlayerModel(number: 7, name: "John Elway", position: "QB")
        awayQB.team = awayTeam
        awayTeam.players.append(awayQB)
        
        let awayRB = PlayerModel(number: 34, name: "Walter Payton", position: "RB")
        awayRB.team = awayTeam
        awayTeam.players.append(awayRB)
        
        let awayWR = PlayerModel(number: 88, name: "Michael Irvin", position: "WR")
        awayWR.team = awayTeam
        awayTeam.players.append(awayWR)
        
        modelContext.insert(homeTeam)
        modelContext.insert(awayTeam)
    }
    
    private func deleteTeams(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(teams[index])
            }
        }
    }
}

struct TeamRow: View {
    let team: TeamModel
    
    var body: some View {
        HStack {
            Circle()
                .fill(team.primaryColor)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading) {
                Text(team.name)
                    .font(.headline)
                
                Text("\(team.players.count) players")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(team.shortName)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(5)
                .background(team.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}

struct TeamDetailView: View {
    let team: TeamModel
    
    var body: some View {
        List {
            Section(header: Text("Team Info")) {
                HStack {
                    Text("Name")
                    Spacer()
                    Text(team.name)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Short Name")
                    Spacer()
                    Text(team.shortName)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Primary Color")
                    Spacer()
                    Rectangle()
                        .fill(team.primaryColor)
                        .frame(width: 20, height: 20)
                }
                
                HStack {
                    Text("Secondary Color")
                    Spacer()
                    Rectangle()
                        .fill(team.secondaryColor)
                        .frame(width: 20, height: 20)
                }
            }
            
            Section(header: Text("Players")) {
                ForEach(team.players) { player in
                    HStack {
                        Text("#\(player.number)")
                            .font(.headline)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading) {
                            Text(player.name)
                                .font(.headline)
                            
                            Text(player.position)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Section(header: Text("Stats")) {
                HStack {
                    Text("Total Yards")
                    Spacer()
                    Text("\(team.totalYards)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Passing Yards")
                    Spacer()
                    Text("\(team.passingYards)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Rushing Yards")
                    Spacer()
                    Text("\(team.rushingYards)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Time of Possession")
                    Spacer()
                    Text(team.formattedTimeOfPossession)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(team.name)
    }
}

struct NewTeamView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var teamName = ""
    @State private var shortName = ""
    @State private var primaryColorHex = "0000FF"  // Default blue
    @State private var secondaryColorHex = "FFFFFF"  // Default white
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Team Details")) {
                    TextField("Team Name", text: $teamName)
                    TextField("Short Name (3-5 letters)", text: $shortName)
                        .onChange(of: shortName) { oldValue, newValue in
                            shortName = String(newValue.prefix(5)).uppercased()
                        }
                }
                
                Section(header: Text("Team Colors")) {
                    ColorPicker("Primary Color", selection: Binding(
                        get: { Color(hex: primaryColorHex) },
                        set: { newColor in
                            // This is simplified - in a real app you'd convert the color to hex
                            primaryColorHex = "0000FF" // Just using blue for simplicity
                        }
                    ))
                    
                    ColorPicker("Secondary Color", selection: Binding(
                        get: { Color(hex: secondaryColorHex) },
                        set: { newColor in
                            // This is simplified - in a real app you'd convert the color to hex
                            secondaryColorHex = "FFFFFF" // Just using white for simplicity
                        }
                    ))
                }
            }
            .navigationTitle("New Team")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTeam()
                        dismiss()
                    }
                    .disabled(teamName.isEmpty || shortName.isEmpty)
                }
            }
        }
    }
    
    private func saveTeam() {
        let newTeam = TeamModel(
            name: teamName,
            shortName: shortName,
            primaryColorHex: primaryColorHex,
            secondaryColorHex: secondaryColorHex
        )
        
        modelContext.insert(newTeam)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TeamModel.self, PlayerModel.self, DriveModel.self, PlayModel.self], inMemory: true)
}
