import Foundation

// MARK: - Player Model
struct Player: Identifiable, Codable {
    let id = UUID()
    let number: Int
    let name: String
    let position: String
}

// MARK: - Team Model
struct Team: Codable {
    let name: String
    let isHome: Bool
    let primaryColor: String
    var quarterbacks: [Player]
    var receivers: [Player]
    var runners: [Player]
    var kickers: [Player]
}

// MARK: - Play Model
struct Play: Identifiable, Codable {
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
struct Drive: Identifiable, Codable {
    let id = UUID()
    let sequence: Int
    let team: Team
    var startYardLine: Int
    var currentYardLine: Int
    var startTime: String
    var endTime: String?
    var result: DriveResult?
    var plays: [Play]
    var possession: String? // time of possession
    
    var totalYards: Int {
        return plays.reduce(0) { $0 + $1.yards }
    }
    
    var firstDowns: Int {
        return plays.filter { $0.isFirstDown }.count
    }
}

// MARK: - Score Model
struct Score: Codable {
    var points: Int
    var touchdowns: Int
    var fieldGoals: Int
    var extraPoints: Int
    var twoPointConversions: Int
    var safeties: Int
    
    init() {
        self.points = 0
        self.touchdowns = 0
        self.fieldGoals = 0
        self.extraPoints = 0
        self.twoPointConversions = 0
        self.safeties = 0
    }
}

// MARK: - PlayerScore Model
struct PlayerScore: Identifiable, Codable {
    let id = UUID()
    let player: Player
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
enum PlayType: String, CaseIterable, Codable {
    case run = "Run"
    case pass = "Pass"
    case scoring = "Scoring"
}

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

enum DriveResult: String, CaseIterable, Codable {
    case touchdown = "Touchdown"
    case fieldGoal = "Field Goal"
    case punt = "Punt"
    case turnover = "Turnover"
    case turnoverOnDowns = "Turnover on Downs"
    case endOfHalf = "End of Half"
    case endOfGame = "End of Game"
}
