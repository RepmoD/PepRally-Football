import Foundation
import Combine

class GameManager: ObservableObject {
    // MARK: - Published Properties
    @Published var homeTeam: Team
    @Published var awayTeam: Team
    @Published var homeScore = Score()
    @Published var awayScore = Score()
    @Published var playerScores: [String: [PlayerScore]] = ["home": [], "away": []]
    @Published var activeDrive: Drive?
    @Published var drives: [Drive] = []
    @Published var activeTeam: Team?
    @Published var currentDown: Int = 1
    @Published var yardsToGo: Int = 10
    @Published var playType: PlayType = .run
    
    // MARK: - Other Properties
    private(set) var currentPlay: PlayData
    
    // MARK: - Initializer
    init() {
        // Initialize with default teams and players
        self.homeTeam = Team(
            name: "Home",
            isHome: true,
            primaryColor: "blue",
            quarterbacks: [
                Player(number: 12, name: "Brady", position: "QB"),
                Player(number: 7, name: "Rivers", position: "QB")
            ],
            receivers: [
                Player(number: 80, name: "Smith", position: "WR"),
                Player(number: 88, name: "Jones", position: "WR"),
                Player(number: 84, name: "Brown", position: "TE")
            ],
            runners: [
                Player(number: 22, name: "Williams", position: "RB"),
                Player(number: 26, name: "Taylor", position: "RB"),
                Player(number: 30, name: "Harris", position: "FB")
            ],
            kickers: [
                Player(number: 3, name: "Tucker", position: "K")
            ]
        )
        
        self.awayTeam = Team(
            name: "Away",
            isHome: false,
            primaryColor: "red",
            quarterbacks: [
                Player(number: 9, name: "Stafford", position: "QB"),
                Player(number: 5, name: "Jackson", position: "QB")
            ],
            receivers: [
                Player(number: 81, name: "Johnson", position: "WR"),
                Player(number: 85, name: "Cooper", position: "WR"),
                Player(number: 87, name: "Andrews", position: "TE")
            ],
            runners: [
                Player(number: 23, name: "Barkley", position: "RB"),
                Player(number: 25, name: "Edwards", position: "RB"),
                Player(number: 45, name: "Ricard", position: "FB")
            ],
            kickers: [
                Player(number: 4, name: "Butker", position: "K")
            ]
        )
        
        // Initialize current play data
        self.currentPlay = PlayData()
    }
    
    // MARK: - Team Selection
    func selectTeam(_ team: Team) {
        // Only allow team selection when no active drive
        guard activeDrive == nil else { return }
        activeTeam = team
    }
    
    // MARK: - Drive Management
    func startNewDrive(startYardLine: Int, startTime: String) {
        guard let team = activeTeam else { return }
        
        let newDrive = Drive(
            sequence: drives.count + 1,
            team: team,
            startYardLine: startYardLine,
            currentYardLine: startYardLine,
            startTime: startTime,
            endTime: nil,
            result: nil,
            plays: []
        )
        
        activeDrive = newDrive
        currentDown = 1
        yardsToGo = 10
    }
    
    func endDrive(endTime: String, result: DriveResult) {
        guard var drive = activeDrive else { return }
        
        drive.endTime = endTime
        drive.result = result
        
        // Calculate possession time (simplified)
        let startTimeParts = drive.startTime.split(separator: ":")
        let endTimeParts = endTime.split(separator: ":")
        
        if startTimeParts.count == 2 && endTimeParts.count == 2,
           let startMinutes = Int(startTimeParts[0]),
           let startSeconds = Int(startTimeParts[1]),
           let endMinutes = Int(endTimeParts[0]),
           let endSeconds = Int(endTimeParts[1]) {
            
            let startTotalSeconds = (startMinutes * 60) + startSeconds
            let endTotalSeconds = (endMinutes * 60) + endSeconds
            let possessionSeconds = max(0, startTotalSeconds - endTotalSeconds)
            
            let minutes = possessionSeconds / 60
            let seconds = possessionSeconds % 60
            drive.possession = String(format: "%d:%02d", minutes, seconds)
        }
        
        // Handle scoring
        if result == .touchdown {
            // Award 6 points (extra point would be handled separately)
            if drive.team.isHome {
                homeScore.touchdowns += 1
                homeScore.points += 6
            } else {
                awayScore.touchdowns += 1
                awayScore.points += 6
            }
        } else if result == .fieldGoal {
            if drive.team.isHome {
                homeScore.fieldGoals += 1
                homeScore.points += 3
            } else {
                awayScore.fieldGoals += 1
                awayScore.points += 3
            }
        }
        
        drives.append(drive)
        activeDrive = nil
    }
    
    // MARK: - Play Management
    func setPlayType(_ type: PlayType) {
        playType = type
        currentPlay = PlayData()
    }
    
    func updateCurrentPlay(
        quarterback: Player? = nil,
        receiver: Player? = nil,
        runner: Player? = nil,
        yards: Int? = nil,
        isComplete: Bool? = nil
    ) {
        if let quarterback = quarterback {
            currentPlay.quarterback = String(quarterback.number)
            currentPlay.quarterbackName = quarterback.name
        }
        
        if let receiver = receiver {
            currentPlay.receiver = String(receiver.number)
            currentPlay.receiverName = receiver.name
        }
        
        if let runner = runner {
            currentPlay.runner = String(runner.number)
            currentPlay.runnerName = runner.name
        }
        
        if let yards = yards {
            currentPlay.yards = yards
        }
        
        if let isComplete = isComplete {
            currentPlay.isComplete = isComplete
        }
    }
    
    func addPlay() {
        guard var drive = activeDrive else { return }
        
        let yards = currentPlay.yards
        let currentYardLine = drive.currentYardLine + yards
        let downSuffix = getDownSuffix(down: currentDown)
        let downPrefix = "\(currentDown)\(downSuffix) & \(yardsToGo): "
        
        var playDescription = ""
        
        if playType == .pass {
            if currentPlay.isComplete {
                playDescription = "\(downPrefix)Pass #\(currentPlay.quarterback) \(currentPlay.quarterbackName ?? "") to #\(currentPlay.receiver) \(currentPlay.receiverName ?? ""), \(yards) yards"
            } else {
                playDescription = "\(downPrefix)Pass #\(currentPlay.quarterback) \(currentPlay.quarterbackName ?? ""), incomplete"
            }
        } else {
            playDescription = "\(downPrefix)Run #\(currentPlay.runner) \(currentPlay.runnerName ?? ""), \(yards) yards"
        }
        
        // Check for first down
        let isFirstDown = yards >= yardsToGo
        if isFirstDown {
            playDescription += " (FIRST DOWN)"
        }
        
        let newPlay = Play(
            sequence: drive.plays.count + 1,
            type: playType,
            description: playDescription,
            yards: yards,
            isFirstDown: isFirstDown,
            isScoring: false,
            quarterback: currentPlay.quarterback,
            quarterbackName: currentPlay.quarterbackName,
            receiver: currentPlay.receiver,
            receiverName: currentPlay.receiverName,
            runner: currentPlay.runner,
            runnerName: currentPlay.runnerName,
            isComplete: currentPlay.isComplete,
            down: currentDown,
            yardsToGo: yardsToGo
        )
        
        drive.plays.append(newPlay)
        drive.currentYardLine = currentYardLine
        
        activeDrive = drive
        
        // Update down and distance
        if isFirstDown {
            currentDown = 1
            yardsToGo = 10
        } else {
            currentDown = (currentDown < 4) ? currentDown + 1 : 1
            yardsToGo = max(0, yardsToGo - yards)
        }
        
        // Reset current play
        currentPlay = PlayData()
    }
    
    // MARK: - Scoring
    func addScore(type: ScoreType, player: Player, kicker: Player? = nil) {
        guard var drive = activeDrive else { return }
        
        var description = ""
        var teamKey = ""
        var playerScoreKey = ""
        
        if drive.team.isHome {
            teamKey = "home"
        } else {
            teamKey = "away"
        }
        
        // Update team score
        switch type {
        case .touchdown:
            description = "TOUCHDOWN: #\(player.number) \(player.name) (6 pts)"
            if drive.team.isHome {
                homeScore.touchdowns += 1
                homeScore.points += 6
            } else {
                awayScore.touchdowns += 1
                awayScore.points += 6
            }
            
        case .fieldGoal:
            description = "FIELD GOAL: #\(player.number) \(player.name) (3 pts)"
            if drive.team.isHome {
                homeScore.fieldGoals += 1
                homeScore.points += 3
            } else {
                awayScore.fieldGoals += 1
                awayScore.points += 3
            }
            
        case .extraPoint:
            description = "EXTRA POINT: #\(player.number) \(player.name) (1 pt)"
            if drive.team.isHome {
                homeScore.extraPoints += 1
                homeScore.points += 1
            } else {
                awayScore.extraPoints += 1
                awayScore.points += 1
            }
            
        case .twoPointConversion:
            description = "2-PT CONVERSION: #\(player.number) \(player.name) (2 pts)"
            if drive.team.isHome {
                homeScore.twoPointConversions += 1
                homeScore.points += 2
            } else {
                awayScore.twoPointConversions += 1
                awayScore.points += 2
            }
            
        case .safety:
            description = "SAFETY: #\(player.number) \(player.name) (2 pts)"
            if drive.team.isHome {
                homeScore.safeties += 1
                homeScore.points += 2
            } else {
                awayScore.safeties += 1
                awayScore.points += 2
            }
        }
        
        // Update player score
        playerScoreKey = String(player.number)
        if var existingScores = playerScores[teamKey] {
            if let index = existingScores.firstIndex(where: { String($0.player.number) == playerScoreKey }) {
                switch type {
                case .touchdown:
                    existingScores[index].touchdowns += 1
                case .fieldGoal:
                    existingScores[index].fieldGoals += 1
                case .extraPoint:
                    existingScores[index].extraPoints += 1
                case .twoPointConversion:
                    existingScores[index].twoPointConversions += 1
                case .safety:
                    existingScores[index].safeties += 1
                }
                playerScores[teamKey] = existingScores
            } else {
                var newPlayerScore = PlayerScore(player: player)
                switch type {
                case .touchdown:
                    newPlayerScore.touchdowns = 1
                case .fieldGoal:
                    newPlayerScore.fieldGoals = 1
                case .extraPoint:
                    newPlayerScore.extraPoints = 1
                case .twoPointConversion:
                    newPlayerScore.twoPointConversions = 1
                case .safety:
                    newPlayerScore.safeties = 1
                }
                existingScores.append(newPlayerScore)
                playerScores[teamKey] = existingScores
            }
        } else {
            var newPlayerScore = PlayerScore(player: player)
            switch type {
            case .touchdown:
                newPlayerScore.touchdowns = 1
            case .fieldGoal:
                newPlayerScore.fieldGoals = 1
            case .extraPoint:
                newPlayerScore.extraPoints = 1
            case .twoPointConversion:
                newPlayerScore.twoPointConversions = 1
            case .safety:
                newPlayerScore.safeties = 1
            }
            playerScores[teamKey] = [newPlayerScore]
        }
        
        // Add scoring play to drive
        let scoringPlay = Play(
            sequence: drive.plays.count + 1,
            type: .scoring,
            description: description,
            yards: 0,
            isFirstDown: false,
            isScoring: true,
            quarterback: nil,
            quarterbackName: nil,
            receiver: nil,
            receiverName: nil,
            runner: nil,
            runnerName: nil,
            isComplete: nil,
            down: currentDown,
            yardsToGo: yardsToGo
        )
        
        drive.plays.append(scoringPlay)
        activeDrive = drive
    }
    
    // MARK: - Helper Functions
    func getEligibleScoringPlayers(for team: Team, type: ScoreType) -> [Player] {
        var eligiblePlayers: [Player] = []
        
        switch type {
        case .fieldGoal, .extraPoint:
            eligiblePlayers = team.kickers
        case .twoPointConversion:
            eligiblePlayers = team.quarterbacks + team.runners + team.receivers
        case .touchdown, .safety:
            eligiblePlayers = team.quarterbacks + team.runners + team.receivers
        }
        
        return eligiblePlayers
    }
    
    private func getDownSuffix(down: Int) -> String {
        switch down {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    func formatTimeInput(_ input: String) -> String {
        // Remove any non-numeric characters
        let numericOnly = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if numericOnly.isEmpty {
            return ""
        }
        
        // Handle different input lengths
        if numericOnly.count <= 2 {
            // Just seconds (e.g., 43 -> 0:43)
            return "0:\(numericOnly.padLeft(toLength: 2, withPad: "0"))"
        } else if numericOnly.count <= 4 {
            // Minutes and seconds (e.g., 835 -> 8:35)
            let minutes = numericOnly.prefix(numericOnly.count - 2)
            let seconds = numericOnly.suffix(2)
            return "\(minutes):\(seconds)"
        } else {
            // Too many digits, truncate to 4
            let truncated = String(numericOnly.prefix(4))
            let minutes = truncated.prefix(truncated.count - 2)
            let seconds = truncated.suffix(2)
            return "\(minutes):\(seconds)"
        }
    }
    
    // MARK: - Statistics
    func calculateStats() -> [String: [String: Int]] {
        var stats: [String: [String: Int]] = [
            "home": ["totalYards": 0, "passingYards": 0, "rushingYards": 0, "possession": 0],
            "away": ["totalYards": 0, "passingYards": 0, "rushingYards": 0, "possession": 0]
        ]
        
        for drive in drives {
            let teamKey = drive.team.isHome ? "home" : "away"
            
            for play in drive.plays {
                // Create a local copy of the team stats dictionary
                var teamStats = stats[teamKey] ?? [:]
                
                if play.type == .pass, play.isComplete == true {
                    teamStats["passingYards"] = (teamStats["passingYards"] ?? 0) + play.yards
                    teamStats["totalYards"] = (teamStats["totalYards"] ?? 0) + play.yards
                } else if play.type == .run {
                    teamStats["rushingYards"] = (teamStats["rushingYards"] ?? 0) + play.yards
                    teamStats["totalYards"] = (teamStats["totalYards"] ?? 0) + play.yards
                }
                
                // Update the main stats dictionary with the modified copy
                stats[teamKey] = teamStats
            }
        }
        
        return stats
    }
    } 

// MARK: - Helper classes
struct PlayData {
    var quarterback: String = ""
    var quarterbackName: String? = nil
    var receiver: String = ""
    var receiverName: String? = nil
    var runner: String = ""
    var runnerName: String? = nil
    var yards: Int = 0
    var isComplete: Bool = true
}


