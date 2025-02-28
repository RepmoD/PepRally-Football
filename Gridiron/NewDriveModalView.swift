import SwiftUI

// MARK: - New Drive Modal View
struct NewDriveModalView: View {
    let activeTeam: Team?
    @Binding var startYardLine: String
    @Binding var startTimeRaw: String
    @Binding var startTimeFormatted: String
    let onTimeChange: (String) -> Void
    let onCancel: () -> Void
    let onStartDrive: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Drive - \(activeTeam?.name.uppercased() ?? "")")) {
                    TextField("Starting Yard Line (e.g., 25)", text: $startYardLine)
                        
                    
                    VStack(alignment: .leading) {
                        TextField("Start Time (e.g., 1500, 245, 58)", text: $startTimeRaw)
                            .onChange(of: startTimeRaw) { oldValue, newValue in
                                onTimeChange(newValue)
                            }
                        
                        Text("Will be formatted as: \(startTimeFormatted.isEmpty ? "0:00" : startTimeFormatted)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    HStack {
                        Button("Cancel") {
                            onCancel()
                        }
                        
                        Spacer()
                        
                        Button("Start Drive") {
                            onStartDrive()
                        }
                        .foregroundColor(.green)
                        .disabled(startYardLine.isEmpty || startTimeFormatted.isEmpty)
                    }
                }
            }
            .navigationTitle("Start New Drive")
        }
    }
}
