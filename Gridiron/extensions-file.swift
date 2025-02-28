import SwiftUI

// MARK: - Extensions for UI
extension Color {
    static let teamHome = Color.blue
    static let teamAway = Color.red
    static let successGreen = Color.green
    static let warningYellow = Color.yellow
    static let dangerRed = Color.red
    
    static func teamColor(isHome: Bool) -> Color {
        return isHome ? teamHome : teamAway
    }
}

// MARK: - Extensions for Model Helpers
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: Identifiable {
    func firstIndex(matching element: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == element.id {
                return index
            }
        }
        return nil
    }
}

// MARK: - Extensions for Data Formatting
extension String {
    func padLeft(toLength length: Int, withPad character: Character) -> String {
        let paddingLength = length - self.count
        guard paddingLength > 0 else { return self }
        return String(repeating: character, count: paddingLength) + self
    }
    
    func formatGameClock() -> String {
        // Remove any non-numeric characters
        let numericOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if numericOnly.isEmpty {
            return "0:00"
        }
        
        if numericOnly.count <= 2 {
            // Just seconds
            return "0:\(numericOnly.padLeft(toLength: 2, withPad: "0"))"
        } else if numericOnly.count <= 4 {
            // Minutes and seconds
            let minutes = numericOnly.prefix(numericOnly.count - 2)
            let seconds = numericOnly.suffix(2)
            return "\(minutes):\(seconds)"
        } else {
            // Truncate
            let truncated = String(numericOnly.prefix(4))
            let minutes = truncated.prefix(truncated.count - 2)
            let seconds = truncated.suffix(2)
            return "\(minutes):\(seconds)"
        }
    }
}

// MARK: - Extensions for File Handling
extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func saveJSON<T: Encodable>(_ object: T, to filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: [.atomicWrite])
        } catch {
            print("Error saving JSON: \(error.localizedDescription)")
        }
    }
    
    static func loadJSON<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Error loading JSON: \(error.localizedDescription)")
            return nil
        }
    }
}
