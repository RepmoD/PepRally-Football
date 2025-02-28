import SwiftUI

// MARK: - Play Input Area
struct PlayInputAreaView: View {
    @ObservedObject var gameManager: GameManager
    let onAddScore: () -> Void
    let onEndDrive: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Down and Distance Info
            Text("\(gameManager.currentDown)\(getDownSuffix(gameManager.currentDown)) & \(gameManager.yardsToGo) at the \(gameManager.activeDrive?.currentYardLine ?? 0) yard line")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            // Play Type Selection
            HStack {
                Button(action: {
                    gameManager.setPlayType(.run)
                }) {
                    Text("RUN")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .foregroundColor(gameManager.playType == .run ? .white : .black)
                        .background(gameManager.playType == .run ? Color.green : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    gameManager.setPlayType(.pass)
                }) {
                    Text("PASS")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .foregroundColor(gameManager.playType == .pass ? .white : .black)
                        .background(gameManager.playType == .pass ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
            
            // Player and Yards Input
            if gameManager.playType == .pass {
                PassPlayInputs(gameManager: gameManager)
            } else {
                RunPlayInputs(gameManager: gameManager)
            }
            
            // Action Buttons
            HStack {
                Button(action: {
                    gameManager.addPlay()
                }) {
                    Text("ADD PLAY")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .disabled(isAddPlayDisabled)
                
                Button(action: {
                    onAddScore()
                }) {
                    Text("ADD SCORE")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
            }
            
            Button(action: {
                onEndDrive()
            }) {
                Text("END DRIVE")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
    
    private var isAddPlayDisabled: Bool {
        if gameManager.playType == .run {
            return gameManager.currentPlay.runner.isEmpty || gameManager.currentPlay.yards == 0
        } else {
            return gameManager.currentPlay.quarterback.isEmpty ||
                  (gameManager.currentPlay.isComplete &&
                   (gameManager.currentPlay.receiver.isEmpty || gameManager.currentPlay.yards == 0))
        }
    }
    
    private func getDownSuffix(_ down: Int) -> String {
        switch down {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}
