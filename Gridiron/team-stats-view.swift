import SwiftUI

// MARK: - Team Stats View
struct TeamStatsView: View {
    let homeScore: Score
    let awayScore: Score
    let stats: [String: [String: Int]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Team Stats")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack(alignment: .top) {
                // Home Team Stats
                VStack(alignment: .leading, spacing: 4) {
                    Text("HOME (\(homeScore.points))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Total: \(stats["home"]?["totalYards"] ?? 0) yards")
                        .font(.caption)
                    Text("Passing: \(stats["home"]?["passingYards"] ?? 0) yards")
                        .font(.caption)
                    Text("Rushing: \(stats["home"]?["rushingYards"] ?? 0) yards")
                        .font(.caption)
                    
                    HStack(spacing: 4) {
                        Text("Scoring:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        if homeScore.touchdowns > 0 {
                            Text("TD: \(homeScore.touchdowns)")
                                .font(.caption)
                        }
                        if homeScore.fieldGoals > 0 {
                            Text("FG: \(homeScore.fieldGoals)")
                                .font(.caption)
                        }
                        if homeScore.extraPoints > 0 {
                            Text("XP: \(homeScore.extraPoints)")
                                .font(.caption)
                        }
                        if homeScore.twoPointConversions > 0 {
                            Text("2PT: \(homeScore.twoPointConversions)")
                                .font(.caption)
                        }
                        if homeScore.safeties > 0 {
                            Text("SAF: \(homeScore.safeties)")
                                .font(.caption)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Away Team Stats
                VStack(alignment: .leading, spacing: 4) {
                    Text("AWAY (\(awayScore.points))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Total: \(stats["away"]?["totalYards"] ?? 0) yards")
                        .font(.caption)
                    Text("Passing: \(stats["away"]?["passingYards"] ?? 0) yards")
                        .font(.caption)
                    Text("Rushing: \(stats["away"]?["rushingYards"] ?? 0) yards")
                        .font(.caption)
                    
                    HStack(spacing: 4) {
                        Text("Scoring:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        if awayScore.touchdowns > 0 {
                            Text("TD: \(awayScore.touchdowns)")
                                .font(.caption)
                        }
                        if awayScore.fieldGoals > 0 {
                            Text("FG: \(awayScore.fieldGoals)")
                                .font(.caption)
                        }
                        if awayScore.extraPoints > 0 {
                            Text("XP: \(awayScore.extraPoints)")
                                .font(.caption)
                        }
                        if awayScore.twoPointConversions > 0 {
                            Text("2PT: \(awayScore.twoPointConversions)")
                                .font(.caption)
                        }
                        if awayScore.safeties > 0 {
                            Text("SAF: \(awayScore.safeties)")
                                .font(.caption)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.top, 8)
    }
}
