//
//  PlayComponents.swift
//  Gridiron
//
//  Created by David Brazeal on 2/24/25.
//

import SwiftUI

// MARK: - Play Input Components

struct YardageInput: View {
    @Binding var yards: String
    
    var body: some View {
        HStack {
            Text("Yards")
                .font(.headline)
            
            TextField("0", text: $yards)
                .keyboardType(.numberPad)  // Fixed: Properly specify keyboard type
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 80)
                .multilineTextAlignment(.trailing)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)  // Fixed: Properly using cornerRadius
    }
}

struct PlayerButton: View {
    var player: Player
    var isSelected: Bool
    var team: TeamModel
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text("#\(player.number)")
                    .font(.headline)
                    .padding(8)
                    .frame(width: 50, height: 50)
                    .background(isSelected ? team.primaryColor : Color(.systemGray5))
                    .foregroundColor(isSelected ? .white : .primary)
                    .cornerRadius(8)  // Fixed: Properly using cornerRadius
                
                Text(player.name.split(separator: " ").first ?? "")
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }
}

struct PlayTypeSelector: View {
    @Binding var selectedType: PlayType
    var team: TeamModel
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(PlayType.allCases) { type in
                Button(action: {
                    selectedType = type
                }) {
                    Text(type.rawValue)
                        .font(.headline)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(selectedType == type ? team.primaryColor : Color(.systemGray5))
                        .foregroundColor(selectedType == type ? .white : .primary)
                        .cornerRadius(8)  // Fixed: Properly using cornerRadius
                }
            }
        }
    }
}

struct PassCompletionToggle: View {
    @Binding var isComplete: Bool
    var team: TeamModel
    
    var body: some View {
        Toggle(isOn: $isComplete) {
            Text("Complete Pass")
                .font(.headline)
        }
        .toggleStyle(SwitchToggleStyle(tint: team.primaryColor))
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)  // Fixed: Properly using cornerRadius
    }
}

struct AddPlayButton: View {
    var playType: PlayType
    var isEnabled: Bool
    var team: TeamModel
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Add \(playType.rawValue)")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? team.primaryColor : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)  // Fixed: Properly using cornerRadius
        }
        .disabled(!isEnabled)
    }
}

// MARK: - Play Summary Components

struct PlaySummaryRow: View {
    var play: PlayModel
    
    var body: some View {
        HStack {
            // Play type icon
            Image(systemName: play.type == PlayType.pass.rawValue ? "arrowtriangle.right.fill" : "figure.run")
                .foregroundColor(play.type == PlayType.pass.rawValue ? .blue : .green)
                .frame(width: 24, height: 24)
            
            // Play description
            if play.type == PlayType.pass.rawValue {
                if play.isComplete, let receiver = play.receiver {
                    Text("Pass: #\(play.player?.number ?? 0) to #\(receiver.number), \(play.yards) yards")
                } else {
                    Text("Pass: #\(play.player?.number ?? 0), incomplete")
                }
            } else {
                Text("Run: #\(play.player?.number ?? 0), \(play.yards) yards")
            }
            
            Spacer()
            
            // Yardage gained/lost
            Text("\(play.yards > 0 ? "+" : "")\(play.yards)")
                .fontWeight(.bold)
                .foregroundColor(play.yards >= 0 ? .green : .red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)  // Fixed: Properly using cornerRadius
    }
}

// MARK: - Player Selection Component

struct PlayerSelectionGrid: View {
    var players: [Player]
    var selectedPlayerId: UUID?
    var team: TeamModel
    var onPlayerSelected: (Player) -> Void
    
    // Group players by position for organized selection
    private var groupedPlayers: [Position: [Player]] {
        Dictionary(grouping: players) { $0.position }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(Position.allCases, id: \.self) { position in
                    if let positionPlayers = groupedPlayers[position], !positionPlayers.isEmpty {
                        VStack(alignment: .leading) {
                            Text(position.rawValue)
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(positionPlayers) { player in
                                        PlayerButton(
                                            player: player,
                                            isSelected: player.id == selectedPlayerId,
                                            team: team,
                                            action: { onPlayerSelected(player) }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Drive Controls

struct StartDriveForm: View {
    @Binding var yardLine: String
    @Binding var gameTime: String
    var onStart: () -> Void
    var isValid: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Starting Yard Line", text: $yardLine)
                .keyboardType(.numberPad)  // Fixed: Properly specify keyboard type
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)  // Fixed: Properly using cornerRadius
            
            TextField("Game Clock (MM:SS)", text: $gameTime)
                .keyboardType(.numbersAndPunctuation)  // Fixed: Properly specify keyboard type
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)  // Fixed: Properly using cornerRadius
            
            Button(action: onStart) {
                Text("Start Drive")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)  // Fixed: Properly using cornerRadius
            }
            .disabled(!isValid)
        }
        .padding()
    }
}

struct EndDriveForm: View {
    @Binding var gameTime: String
    @Binding var result: DriveResult
    var onEnd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Game Clock (MM:SS)", text: $gameTime)
                .keyboardType(.numbersAndPunctuation)  // Fixed: Properly specify keyboard type
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)  // Fixed: Properly using cornerRadius
            
            Text("Drive Result")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(DriveResult.allCases) { driveResult in
                Button(action: {
                    result = driveResult
                }) {
                    HStack {
                        Text(driveResult.rawValue)
                        
                        Spacer()
                        
                        if result == driveResult {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)  // Fixed: Properly using cornerRadius
                }
            }
            
            Button(action: onEnd) {
                Text("End Drive")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!gameTime.isEmpty ? Color.red : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)  // Fixed: Properly using cornerRadius
            }
            .disabled(gameTime.isEmpty)
        }
        .padding()
    }
}
