import SwiftUI

// MARK: - Drive Summaries View
struct DriveSummaryListView: View {
    let drives: [Drive]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drive Summaries")
                .font(.headline)
                .padding(.bottom, 4)
            
            ForEach(drives) { drive in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Drive #\(drive.sequence) - \(drive.team.name.uppercased())")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if let result = drive.result {
                            Text(result.rawValue)
                                .font(.caption)
                        }
                    }
                    
                    Text("Yard \(drive.startYardLine) | \(drive.startTime) - \(drive.endTime ?? "N/A") | \(drive.possession ?? "N/A")")
                        .font(.caption)
                    
                    Text("\(drive.plays.count) plays, \(drive.totalYards) yards, \(drive.firstDowns) first downs")
                        .font(.caption)
                }
                .padding(.vertical, 8)
                
                if drive.id != drives.last?.id {
                    Divider()
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
