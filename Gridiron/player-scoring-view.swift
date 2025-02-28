import SwiftUI

// MARK: - Player Scoring Summary View
struct PlayerScoringSummaryView: View {
    let homePlayerScores: [PlayerScore]
    let awayPlayerScores: [PlayerScore]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Player Scoring")
                .font(.headline)
                .padding(.bottom, 4)
            
            // Home Team Players
            VStack(alignment: .leading, spacing: 8) {
                Text("HOME")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 4)
                
                if homePlayerScores.isEmpty {
                    Text("No scoring yet")
                        .font(.caption)
                        .padding(.vertical, 4)
                } else {
                    ForEach(homePlayerScores) { score in
                        HStack {
                            Text("#\(score.player.number) \(score.player.name)")
                                .font(.caption)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                if score.touchdowns > 0 {
                                    Text("TD: \(score.touchdowns)")
                                        .font(.caption)
                                }
                                if score.fieldGoals > 0 {
                                    Text("FG: \(score.fieldGoals)")
                                        .font(.caption)
                                }
                                if score.extraPoints > 0 {
                                    Text("XP: \(score.extraPoints)")
                                        .font(.caption)
                                }
                                if score.twoPointConversions > 0 {
                                    Text("2PT: \(score.twoPointConversions)")
                                        .font(.caption)
                                }
                                if score.safeties > 0 {
                                    Text("SAF: \(score.safeties)")
                                        .font(.caption)
                                }
                                
                                Text("(\(score.totalPoints) pts)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        if score.id != homePlayerScores.last?.id {
                            Divider()
                        }
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 8)
            
            // Away Team Players
            VStack(alignment: .leading, spacing: 8) {
                Text("AWAY")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .padding(.bottom, 4)
                
                if awayPlayerScores.isEmpty {
                    Text("No scoring yet")
                        .font(.caption)
                        .padding(.vertical, 4)
                } else {
                    ForEach(awayPlayerScores) { score in
                        HStack {
                            Text("#\(score.player.number) \(score.player.name)")
                                .font(.caption)
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                if score.touchdowns > 0 {
                                    Text("TD: \(score.touchdowns)")
                                        .font(.caption)
                                }
                                if score.fieldGoals > 0 {
                                    Text("FG: \(score.fieldGoals)")
                                        .font(.caption)
                                }
                                if score.extraPoints > 0 {
                                    Text("XP: \(score.extraPoints)")
                                        .font(.caption)
                                }
                                if score.twoPointConversions > 0 {
                                    Text("2PT: \(score.twoPointConversions)")
                                        .font(.caption)
                                }
                                if score.safeties > 0 {
                                    Text("SAF: \(score.safeties)")
                                        .font(.caption)
                                }
                                
                                Text("(\(score.totalPoints) pts)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        if score.id != awayPlayerScores.last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.top, 8)
    }
}
