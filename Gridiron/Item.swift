import Foundation

// MARK: - Player Model
struct PlayerData: Identifiable, Codable {
    let id = UUID()
    let number: Int
    let name: String
    let position: String
}

// MARK: - Team Model
struct TeamData: Identifiable, Codable {
    let id = UUID()
    let name: String
    let isHome: Bool
    let primaryColor: String
    var quarterbacks: [PlayerData]
    var receivers: [PlayerData]
    var runners: [PlayerData]
    var kickers: [PlayerData]
}

// MARK: - Play Model
struct PlayData: Identifiable, Codable {
    let id = UUID()
    let sequence: Int
    let type: PlayType
    let description: String
    let yards: Int
    let isFirstDown: Bool
    let isScoring: Bool
    
    // Specific play details
    var quarterback: String?
    var quarterbackName: String?
    var receiver: String?
    var receiverName: String?
    var runner: String?
    var runnerName: String?
    var isComplete: Bool? // for pass plays
    var down: Int
    var yardsToGo: Int
}

// MARK: - Drive Model
struct DriveData: Identifiable, Codable {
    let id = UUID()
    let sequence: Int
    let team: TeamData
    var startYardLine: Int
    var currentYardLine: Int
    var startTime: String
    var endTime: String?
    var result: DriveResult?
    var plays: [PlayData]
    var possession: String? // time of possession
    
    var totalYards: Int {
        return plays.reduce(0) { $0 + $1.yards }
    }
    
    var firstDowns: Int {
        return plays.filter { $0.isFirstDown }.count
    }
}

// MARK: - Score Model
struct ScoreData: Codable {
    var points: Int = 0
    var touchdowns: Int = 0
    var fieldGoals: Int = 0
    var extraPoints: Int = 0
    var twoPointConversions: Int = 0
    var safeties: Int = 0
}

// MARK: - PlayerScore Model
struct PlayerScoreData: Identifiable, Codable {
    let id = UUID()
    let player: PlayerData
    var touchdowns: Int = 0
    var fieldGoals: Int = 0
    var extraPoints: Int = 0
    var twoPointConversions: Int = 0
    var safeties: Int = 0
    
    var totalPoints: Int {
        return (touchdowns * 6) + (fieldGoals * 3) + extraPoints + (twoPointConversions * 2) + (safeties * 2)
    }
}

// MARK: - Enumerations
enum ScoreType: String, CaseIterable, Codable {
    case touchdown = "Touchdown"
    case fieldGoal = "Field Goal"
    case extraPoint = "Extra Point"
    case twoPointConversion = "Two-Point Conversion"
    case safety = "Safety"
    
    var points: Int {
        switch self {
        case .touchdown: return 6
        case .fieldGoal: return 3
        case .extraPoint: return 1
        case .twoPointConversion: return 2
        case .safety: return 2
        }
    }
}

// MARK: - Utility Structs
struct CurrentPlayData {
    var quarterback: String = ""
    var quarterbackName: String? = nil
    var receiver: String = ""
    var receiverName: String? = nil
    var runner: String = ""
    var runnerName: String? = nil
    var yards: Int = 0
    var isComplete: Bool = true
}

struct GameDataStorage: Codable {
    let drives: [DriveData]
    let homeScore: ScoreData
    let awayScore: ScoreData
    let playerScores: [String: [PlayerScoreData]]
    let lastUpdated: Date
}

struct TeamsDataStorage: Codable {
    let homeTeam: TeamData
    let awayTeam: TeamData
    let lastUpdated: Date
}
