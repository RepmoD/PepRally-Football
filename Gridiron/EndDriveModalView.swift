import SwiftUI

// MARK: - End Drive Modal View
struct EndDriveModalView: View {
    @Binding var endTimeRaw: String
    @Binding var endTimeFormatted: String
    @Binding var driveResult: DriveResult
    let onTimeChange: (String) -> Void
    let onCancel: () -> Void
    let onEndDrive: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("End Drive")) {
                    VStack(alignment: .leading) {
                        TextField("End Time (e.g., 1245, 930, 59)", text: $endTimeRaw)
                            .onChange(of: endTimeRaw) { oldValue, newValue in
                                onTimeChange(newValue)
                            }
                        
                        Text("Will be formatted as: \(endTimeFormatted.isEmpty ? "0:00" : endTimeFormatted)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Picker("Drive Result", selection: $driveResult) {
                        ForEach(DriveResult.allCases, id: \.self) { result in
                            Text(result.rawValue)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Button("Cancel") {
                            onCancel()
                        }
                        
                        Spacer()
                        
                        Button("End Drive") {
                            onEndDrive()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("End Drive")
        }
    }
}
