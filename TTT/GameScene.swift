//
//  GameScene.swift
//  TTT
//
//  Created by Hyung Lee on 7/11/23.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    private var gameState: GameState!
    private var gameBoard: SKShapeNode!
    private var turnLabel: SKLabelNode!
    private var titleLabel: SKLabelNode!
    private var resetButton: SKLabelNode!
    
    private var boardSize: CGSize!
    private var screenSize: CGSize!
    private var boardPos: CGPoint!
    private var cellSize: CGSize!
    
    func setupBoardProperties() {
        boardSize = CGSize(width: 320, height: 320)
        screenSize = UIScreen.main.bounds.size
        boardPos = CGPoint(x: screenSize.width / 2.0 - boardSize.width / 2.0, y: screenSize.height / 2.0 - boardSize.height / 2.0)
        cellSize = CGSize(width: boardSize.width / 3, height: boardSize.height / 3)
    }
    
    private func setupTurnLabel() {
        turnLabel = SKLabelNode(text: "Player X's Turn")
        turnLabel.fontName = "HelveticaNeue-Bold"
        turnLabel.fontSize = 18
        turnLabel.fontColor = UIColor.black
        turnLabel.position = CGPoint(x: frame.midX, y: 160)
        gameBoard.addChild(turnLabel)
    }
    
    // Function to change turn label whenever a player moves
    private func updateTurnLabel() {
        let playerText = (gameState.currentPlayer == .circle) ? "Player X's Turn" : "Player O's Turn"
        turnLabel.text = playerText
    }
    
    private func setupTitleLabel() {
        titleLabel = SKLabelNode(text: "Tic Tac Toe")
        titleLabel.fontName = "HelveticaNeue-Bold"
        titleLabel.fontSize = 28
        titleLabel.fontColor = UIColor.black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.height - 120)
        addChild(titleLabel)
    }
    
    private func setupResetButton() {
        resetButton = SKLabelNode(text: "Reset board")
        resetButton.fontColor = .white
        resetButton.fontName = "HelveticaNeue-Bold"
        resetButton.fontSize = 12
        resetButton.fontColor = UIColor.black
        resetButton.position = CGPoint(x: frame.midX, y: 100)
        
        isUserInteractionEnabled = true
        
        addChild(resetButton)
    }
    
    private func setupGameBoard() {
        scene?.backgroundColor = .white
        gameBoard = SKShapeNode(rect: .init(origin: boardPos, size: boardSize), cornerRadius: 8.0)
        gameBoard.scene?.anchorPoint = .init(x: 0.5, y: 0.5)
        gameBoard.fillColor = .clear
        gameBoard.strokeColor = .black
        gameBoard.lineWidth = 3.0
        
        // Use this parameter to customize how far the tic tac toe lines are from the board perimeter
        let lineOffset: CGFloat = 0.0
        
        let gameBoardPath = CGMutablePath()
        gameBoardPath.addRect(CGRect(origin: boardPos, size: boardSize))
        
        // Add horizontal lines
        let line1 = CGMutablePath()
        line1.move(to: CGPoint(x: boardPos.x + lineOffset, y: boardPos.y + boardSize.height / 3.0))
        line1.addLine(to: CGPoint(x: boardPos.x + boardSize.width - lineOffset, y: boardPos.y + boardSize.height / 3.0))
        gameBoardPath.addPath(line1)
        
        let line2 = CGMutablePath()
        line2.move(to: CGPoint(x: boardPos.x + lineOffset, y: boardPos.y + 2.0 * boardSize.height / 3.0))
        line2.addLine(to: CGPoint(x: boardPos.x + boardSize.width - lineOffset, y: boardPos.y + 2.0 * boardSize.height / 3.0))
        gameBoardPath.addPath(line2)
        
        // Add vertical lines
        let line3 = CGMutablePath()
        line3.move(to: CGPoint(x: boardPos.x + boardSize.width / 3.0, y: boardPos.y + lineOffset))
        line3.addLine(to: CGPoint(x: boardPos.x + boardSize.width / 3.0, y: boardPos.y + boardSize.height - lineOffset))
        gameBoardPath.addPath(line3)
        
        let line4 = CGMutablePath()
        line4.move(to: CGPoint(x: boardPos.x + 2.0 * boardSize.width / 3.0, y: boardPos.y + lineOffset))
        line4.addLine(to: CGPoint(x: boardPos.x + 2.0 * boardSize.width / 3.0, y: boardPos.y + boardSize.height - lineOffset))
        gameBoardPath.addPath(line4)
        
        gameBoard = SKShapeNode(path: gameBoardPath)
        gameBoard.fillColor = .clear
        gameBoard.strokeColor = .black
        gameBoard.lineWidth = 3.0
        addChild(gameBoard)
    }
    
    // Alert once you've won the game or there's a draw. Clicking New Game will start a new game
    private func showPopupMessage(_ message: String) {
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        let resetAction = UIAlertAction(title: "New Game", style: .default) { _ in
            self.resetBoard()
        }
        alert.addAction(resetAction)
        view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // Create cells that will store the player's moves
    func drawGameBoardGrid() {
        let cellOffset = CGPoint(x: boardPos.x, y: boardPos.y)
        
        for row in 0..<3 {
            for column in 0..<3 {
                let cellPosition = CGPoint(x: cellOffset.x + CGFloat(column) * cellSize.width, y: cellOffset.y + CGFloat(row) * cellSize.height)
                let cellNode = SKShapeNode(rect: .init(origin: cellPosition, size: cellSize), cornerRadius: 8.0)
                cellNode.fillColor = .clear
                cellNode.strokeColor = .clear
                gameBoard.addChild(cellNode)
            }
        }
        
        // This function is here because each time the board resets, it becomes Player Xs turn
        setupTurnLabel()
    }
    
    override func sceneDidLoad() {
        
        // Launch screen
        let backgroundNode = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height))
        backgroundNode.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundNode.fillColor = .white
        backgroundNode.zPosition = 1
        addChild(backgroundNode)
        
        titleLabel = SKLabelNode(text: "Tic Tac Toe")
        titleLabel.fontName = "HelveticaNeue-Bold"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        titleLabel.zPosition = 2
        addChild(titleLabel)
        
        // Launch screen animations

        let scaleAction = SKAction.scale(to: 1, duration: 1)
        let fadeOutAction = SKAction.group([SKAction.scale(to: 2, duration: 1), SKAction.fadeOut(withDuration: 1)])
        let animations = SKAction.sequence([scaleAction,fadeOutAction])
        
        // Remove the launch screen from the scene after the animations are over
        let removeAction = SKAction.removeFromParent()
        
        // Run the animations on the title label and background node
        titleLabel.run(SKAction.sequence([animations, removeAction]))
        backgroundNode.run(SKAction.sequence([animations, removeAction]))

        
        // Initialize game state
        gameState = GameState()
        
        // Initialize values
        setupBoardProperties()
        
        // Create game board
        setupGameBoard()
        
        // Add cells to the game board
        drawGameBoardGrid()
        
        // Add title to the game board
        setupTitleLabel()
        
        // Add reset button to the game board
        setupResetButton()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Convert the touch position to the corresponding cell
        let row = (location.y - boardPos.y) / cellSize.height
        let col = (location.x - boardPos.x) / cellSize.width
        
        // Make a move on the selected cell if cell is within board and cell hasn't been taken
        if row <= 3 && row >= 0 && col <= 3 && col >= 0 {
            if gameState.board[Int(row)][Int(col)] == .none {
                gameState.makeMove(row: Int(row), col: Int(col))
                // Update the game board based on the new state
                updateGameBoard()
                // Update player turn label
                updateTurnLabel()
                // Check if you've won the game
                if gameState.checkForWin() {
                    let val = (gameState.currentPlayer.rawValue == 1) ? "X" : "O"
                    let message = "Player \(val) wins!"
                    showPopupMessage(message)
                } else if gameState.isDraw() {
                    let message = "It's a draw!"
                    showPopupMessage(message)
                }
            }
        }

        // If you click on the reset button, the board will reset
        if resetButton.contains(location) {
            resetBoard()
        }
    }
    
    private func updateGameBoard() {
        for row in 0..<3 {
            for col in 0..<3 {
                let cell = gameBoard.children[row * 3 + col] as! SKShapeNode
                let player = gameState.board[row][col]
                
                if player == .cross {
                    // Add cross to board at specified row, col
                    if let xImg = UIImage(systemName: "xmark") {
                        let xTexture = SKTexture(image: xImg)
                        let cross = SKSpriteNode(texture: xTexture)
                        cross.size = .init(width: cell.frame.width / 2, height: cell.frame.height / 2)
                        cross.position = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
                        cross.color = .white
                        
                        gameBoard.addChild(cross)
                    }
                } else if player == .circle {
                    // Add circle
                    if let oImg = UIImage(systemName: "circle") {
                        let oTexture = SKTexture(image: oImg)
                        let circle = SKSpriteNode(texture: oTexture)
                        circle.size = .init(width: cell.frame.width / 2, height: cell.frame.height / 2)
                        circle.position = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
                        circle.color = .white
                        
                        gameBoard.addChild(circle)
                    }
                }
            }
        }
    }
    
    private func resetBoard() {
        gameBoard.removeAllChildren()
        gameState.reset()
        drawGameBoardGrid()
    }
}
