//
//  PlayerModel.swift
//  Gridiron
//
//  Created by David Brazeal on 2/26/25.
//


//
//  GridironModels.swift
//  Gridiron
//
//  Created by David Brazeal on 2/24/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - SwiftData Models

@Model
final class PlayerModel {
    var number: Int
    var name: String
    var position: String
    
    @Relationship(deleteRule: .cascade, inverse: \PlayModel.player)
    var plays: [PlayModel] = []
    
    @Relationship(deleteRule: .cascade, inverse: \PlayModel.receiver)
    var receptions: [PlayModel] = []
    
    @Relationship(deleteRule: .nullify, inverse: \TeamModel.players)
    var team: TeamModel?
    
    init(number: Int, name: String, position: String) {
        self.number = number
        self.name = name
        self.position = position
    }
}

@Model
final class PlayModel {
    var type: String
    var yards: Int
    var isComplete: Bool
    var timestamp: Date
    
    @Relationship(deleteRule: .nullify, inverse: \PlayerModel.plays)
    var player: PlayerModel?
    
    @Relationship(deleteRule: .nullify, inverse: \PlayerModel.receptions)
    var receiver: PlayerModel?
    
    @Relationship(deleteRule: .nullify, inverse: \DriveModel.plays)
    var drive: DriveModel?
    
    init(type: String, yards: Int, isComplete: Bool = true) {
        self.type = type
        self.yards = yards
        self.isComplete = isComplete
        self.timestamp = Date()
    }
}

@Model
final class DriveModel {
    var number: Int
    var startYardLine: Int
    var startTime: Date
    var endTime: Date?
    var result: String
    var timestamp: Date
    
    @Relationship(deleteRule: .nullify, inverse: \TeamModel.drives)
    var team: TeamModel?
    
    @Relationship(deleteRule: .cascade, inverse: \PlayModel.drive)
    var plays: [PlayModel] = []
    
    init(number: Int, startYardLine: Int, startTime: Date, result: String = "") {
        self.number = number
        self.startYardLine = startYardLine
        self.startTime = startTime
        self.result = result
        self.timestamp = Date()
    }
    
    var duration: TimeInterval {
        guard let endTime = endTime else { return 0 }
        return startTime.distance(to: endTime)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var totalYards: Int {
        return plays.reduce(0) { $0 + $1.yards }
    }
}

@Model
final class TeamModel {
    var name: String
    var shortName: String
    var primaryColorHex: String
    var secondaryColorHex: String
    var timestamp: Date
    
    @Relationship(deleteRule: .cascade, inverse: \PlayerModel.team)
    var players: [PlayerModel] = []
    
    @Relationship(deleteRule: .cascade, inverse: \DriveModel.team)
    var drives: [DriveModel] = []
    
    init(name: String, shortName: String, primaryColorHex: String, secondaryColorHex: String) {
        self.name = name
        self.shortName = shortName
        self.primaryColorHex = primaryColorHex
        self.secondaryColorHex = secondaryColorHex
        self.timestamp = Date()
    }
    
    var primaryColor: Color {
        Color(hex: primaryColorHex)
    }
    
    var secondaryColor: Color {
        Color(hex: secondaryColorHex)
    }
    
    var totalYards: Int {
        return drives.flatMap { $0.plays }.reduce(0) { $0 + $1.yards }
    }
    
    var passingYards: Int {
        return drives.flatMap { $0.plays }
            .filter { $0.type == PlayType.pass.rawValue && $0.isComplete }
            .reduce(0) { $0 + $1.yards }
    }
    
    var rushingYards: Int {
        return drives.flatMap { $0.plays }
            .filter { $0.type == PlayType.run.rawValue }
            .reduce(0) { $0 + $1.yards }
    }
    
    var timeOfPossession: TimeInterval {
        return drives.reduce(0) { $0 + $1.duration }
    }
    
    var formattedTimeOfPossession: String {
        let minutes = Int(timeOfPossession) / 60
        let seconds = Int(timeOfPossession) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Extensions
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}