import SwiftUI

// MARK: - Scoring Modal View
struct ScoringModalView: View {
    let team: Team
    @Binding var scoreType: ScoreType
    @Binding var scoringPlayerId: String
    @Binding var kickerId: String
    let eligiblePlayers: (ScoreType) -> [Player]
    let onCancel: () -> Void
    let onAddScore: (ScoreType, String, String?) -> Void
    
    var body: some View {
        #if os(macOS)
        content
            .frame(minWidth: 400, minHeight: 300)
        #else
        NavigationView {
            content
        }
        #endif
    }
    
    private var content: some View {
        Form {
            Section(header: Text("Add Score - \(team.name.uppercased())")) {
                Picker("Score Type", selection: $scoreType) {
                    ForEach(ScoreType.allCases, id: \.self) { type in
                        Text("\(type.rawValue) (\(type.points) pts)")
                    }
                }
                
                Picker("Player", selection: $scoringPlayerId) {
                    Text("Select player...").tag("")
                    ForEach(eligiblePlayers(scoreType), id: \.id) { player in
                        Text("#\(player.number) \(player.name) (\(player.position))").tag(String(player.number))
                    }
                }
                
                if scoreType == .extraPoint {
                    Picker("Kicker", selection: $kickerId) {
                        Text("Select kicker...").tag("")
                        ForEach(team.kickers, id: \.id) { kicker in
                            Text("#\(kicker.number) \(kicker.name) (K)").tag(String(kicker.number))
                        }
                    }
                }
            }
            
            Section {
                HStack {
                    Button("Cancel") {
                        onCancel()
                    }
                    
                    Spacer()
                    
                    Button("Add Score") {
                        onAddScore(scoreType, scoringPlayerId, scoreType == .extraPoint ? kickerId : nil)
                    }
                    .foregroundColor(.yellow)
                    .disabled(scoringPlayerId.isEmpty || (scoreType == .extraPoint && kickerId.isEmpty))
                }
            }
        }
        #if os(iOS)
        .navigationBarTitle("Add Score", displayMode: .inline)
        #endif
    }
}
