import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showExportSheet = false
    @State private var csvData: String = ""
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Export Options")) {
                    Button("Export Game Data as CSV") {
                        csvData = GameDataManager.shared.exportGameDataAsCSV()
                        showExportSheet = true
                    }
                    
                    Button("Reset Game Data") {
                        showResetAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Export & Reset")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showExportSheet) {
                #if os(iOS)
                ShareFileSheet(fileURL: createCSVFile())
                #else
                MacOSShareView(csvData: csvData)
                #endif
            }
            .alert("Reset Game Data", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset Data", role: .destructive) {
                    GameDataManager.shared.resetGameData()
                }
            } message: {
                Text("Are you sure you want to reset all game data? This cannot be undone.")
            }
        }
    }
    
    private func createCSVFile() -> URL {
        // Get a temporary directory to save the file
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("football_stats.csv")
        
        // Write the CSV data to the file
        try? csvData.write(to: fileURL, atomically: true, encoding: .utf8)
        
        return fileURL
    }
}

#if os(iOS)
struct ShareFileSheet: UIViewControllerRepresentable {
    let fileURL: URL
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}
#else
struct MacOSShareView: View {
    var csvData: String
    @State private var showSavePanel = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your CSV data is ready to export")
                .font(.headline)
            
            Button("Save to File") {
                showSavePanel = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Copy to Clipboard") {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(csvData, forType: .string)
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(30)
        .fileExporter(
            isPresented: $showSavePanel,
            document: CSVDocument(csvContent: csvData),
            contentType: .commaSeparatedText,
            defaultFilename: "football_stats.csv"
        ) { result in
            // Handle the result if needed
        }
    }
}

// Document type for saving CSV
struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var csvContent: String
    
    init(csvContent: String) {
        self.csvContent = csvContent
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        csvContent = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = csvContent.data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}
#endif

// Preview provider
struct ExportView_Previews: PreviewProvider {
    static var previews: some View {
        ExportView()
    }
}
