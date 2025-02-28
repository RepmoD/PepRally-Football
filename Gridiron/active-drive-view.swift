import SwiftUI

// MARK: - Active Drive View
struct ActiveDriveView: View {
    let drive: Drive
    let currentDown: Int
    let yardsToGo: Int
    let getDownSuffix: (Int) -> String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Drive #\(drive.sequence) - \(drive.team.name.uppercased())")
                    .font(.headline)
                
                Spacer()
                
                Text("Started at yard \(drive.startYardLine) | \(drive.startTime)")
                    .font(.caption)
            }
            
            // Current Down and Distance
            HStack {
                Text("\(currentDown)\(getDownSuffix(currentDown)) & \(yardsToGo)")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Ball on: Yard \(drive.currentYardLine)")
            }
            .padding(8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
            
            // Plays List
            VStack(alignment: .leading) {
                if drive.plays.isEmpty {
                    Text("No plays added yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                } else {
                    ForEach(drive.plays) { play in
                        VStack(alignment: .leading) {
                            Text(play.description)
                                .padding(.vertical, 4)
                        }
                        .padding(.horizontal, 4)
                        .background(
                            play.isFirstDown ? Color.green.opacity(0.1) :
                            play.isScoring ? Color.yellow.opacity(0.1) : Color.clear
                        )
                        .cornerRadius(4)
                        
                        if play != drive.plays.last {
                            Divider()
                        }
                    }
                    
                    HStack {
                        Text("Total: \(drive.totalYards) yards | \(drive.plays.count) plays | \(drive.firstDowns) first downs")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding(.top, 8)
    }
}
