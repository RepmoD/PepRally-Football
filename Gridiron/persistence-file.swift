import Foundation
import Combine

/// Manages persistent storage of game data
class GameDataManager {
    static let shared = GameDataManager()
    
    private let gameFilename = "football_game_data.json"
    private let teamsFilename = "football_teams_data.json"
    
    // MARK: - Save functions
    func saveGame(drives: [Drive], homeScore: Score, awayScore: Score, playerScores: [String: [PlayerScore]]) {
        let gameData = GameData(
            drives: drives,
            homeScore: homeScore,
            awayScore: awayScore,
            playerScores: playerScores,
            lastUpdated: Date()
        )
        
        FileManager.saveJSON(gameData, to: gameFilename)
    }
    
    func saveTeams(homeTeam: Team, awayTeam: Team) {
        let teamsData = TeamsData(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            lastUpdated: Date()
        )
        
        FileManager.saveJSON(teamsData, to: teamsFilename)
    }
    
    // MARK: - Load functions
    func loadGame() -> (drives: [Drive], homeScore: Score, awayScore: Score, playerScores: [String: [PlayerScore]])? {
        guard let gameData = FileManager.loadJSON(GameData.self, from: gameFilename) else {
            return nil
        }
        
        return (
            drives: gameData.drives,
            homeScore: gameData.homeScore,
            awayScore: gameData.awayScore,
            playerScores: gameData.playerScores
        )
    }
    
    func loadTeams() -> (homeTeam: Team, awayTeam: Team)? {
        guard let teamsData = FileManager.loadJSON(TeamsData.self, from: teamsFilename) else {
            return nil
        }
        
        return (homeTeam: teamsData.homeTeam, awayTeam: teamsData.awayTeam)
    }
    
    // MARK: - Export functions
    func exportGameDataAsCSV() -> String {
        guard let gameData = FileManager.loadJSON(GameData.self, from: gameFilename) else {
            return "No game data available"
        }
        
        // Build CSV string
        var csv = "Game Statistics\n"
        
        // Team scores
        csv += "\nTeam Scores\n"
        csv += "Team,Total,Touchdowns,Field Goals,Extra Points,Two-Point Conversions,Safeties\n"
        csv += "Home,\(gameData.homeScore.points),\(gameData.homeScore.touchdowns),\(gameData.homeScore.fieldGoals),\(gameData.homeScore.extraPoints),\(gameData.homeScore.twoPointConversions),\(gameData.homeScore.safeties)\n"
        csv += "Away,\(gameData.awayScore.points),\(gameData.awayScore.touchdowns),\(gameData.awayScore.fieldGoals),\(gameData.awayScore.extraPoints),\(gameData.awayScore.twoPointConversions),\(gameData.awayScore.safeties)\n"
        
        // Player scores
        csv += "\nPlayer Scoring\n"
        csv += "Team,Player Number,Player Name,Touchdowns,Field Goals,Extra Points,Two-Point Conversions,Safeties,Total Points\n"
        
        // Home players
        for playerScore in gameData.playerScores["home"] ?? [] {
            csv += "Home,\(playerScore.player.number),\(playerScore.player.name),\(playerScore.touchdowns),\(playerScore.fieldGoals),\(playerScore.extraPoints),\(playerScore.twoPointConversions),\(playerScore.safeties),\(playerScore.totalPoints)\n"
        }
        
        // Away players
        for playerScore in gameData.playerScores["away"] ?? [] {
            csv += "Away,\(playerScore.player.number),\(playerScore.player.name),\(playerScore.touchdowns),\(playerScore.fieldGoals),\(playerScore.extraPoints),\(playerScore.twoPointConversions),\(playerScore.safeties),\(playerScore.totalPoints)\n"
        }
        
        // Drives
        csv += "\nDrives\n"
        csv += "Drive Number,Team,Start Yard Line,Start Time,End Time,Result,Plays,Total Yards,First Downs,Possession\n"
        
        for drive in gameData.drives {
            csv += "\(drive.sequence),\(drive.team.name),\(drive.startYardLine),\(drive.startTime),\(drive.endTime ?? ""),\(drive.result?.rawValue ?? ""),\(drive.plays.count),\(drive.totalYards),\(drive.firstDowns),\(drive.possession ?? "")\n"
        }
        
        // Plays
        csv += "\nPlays\n"
        csv += "Drive Number,Play Number,Type,Description,Yards,First Down,Scoring\n"
        
        for drive in gameData.drives {
            for play in drive.plays {
                csv += "\(drive.sequence),\(play.sequence),\(play.type.rawValue),\"\(play.description)\",\(play.yards),\(play.isFirstDown ? "Yes" : "No"),\(play.isScoring ? "Yes" : "No")\n"
            }
        }
        
        return csv
    }
    
    // MARK: - Reset function
    func resetGameData() {
        // Create empty game data
        let gameData = GameData(
            drives: [],
            homeScore: Score(),
            awayScore: Score(),
            playerScores: ["home": [], "away": []],
            lastUpdated: Date()
        )
        
        // Save empty game data
        FileManager.saveJSON(gameData, to: gameFilename)
    }
}

// MARK: - Data Models for Persistence
struct GameData: Codable {
    let drives: [Drive]
    let homeScore: Score
    let awayScore: Score
    let playerScores: [String: [PlayerScore]]
    let lastUpdated: Date
}

struct TeamsData: Codable {
    let homeTeam: Team
    let awayTeam: Team
    let lastUpdated: Date
}
