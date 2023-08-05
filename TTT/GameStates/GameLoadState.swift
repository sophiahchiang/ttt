//
//  GameLoadState.swift
//  TTT
//
//  Created by Hyung Lee on 7/11/23.
//

import SpriteKit
import GameplayKit

enum Player: Int {
    case none = 0
    case cross
    case circle
}

class GameState {
    var currentPlayer: Player = .cross
    var board: [[Player]] = [
        [.none, .none, .none],
        [.none, .none, .none],
        [.none, .none, .none]
    ]
    var numMoves: Int = 0
    
    // Initially did this with a different array, keeping track of how
    // many pieces in each row so I wouldn't be looking through the entire grid every time
    // But this is easier to understand at a glance
    func checkForWin() -> Bool {
        // Check rows
        for row in 0..<3 {
            if board[row][0] == currentPlayer && board[row][1] == currentPlayer && board[row][2] == currentPlayer {
                return true
            }
        }
        // Check columns
        for col in 0..<3 {
            if board[0][col] == currentPlayer && board[1][col] == currentPlayer && board[2][col] == currentPlayer {
                return true
            }
        }
        // Check diagonals
        if board[0][0] == currentPlayer && board[1][1] == currentPlayer && board[2][2] == currentPlayer {
            return true
        }
        if board[2][0] == currentPlayer && board[1][1] == currentPlayer && board[0][2] == currentPlayer {
            return true
        }
        // No one has won yet, so switch currentPlayer and return false
        currentPlayer = currentPlayer == .cross ? .circle : .cross
        return false
    }
    
    func isDraw() -> Bool {
        return numMoves == 9
    }
    
    func makeMove(row: Int, col: Int) {
        numMoves += 1
        if board[row][col] == .none {
            board[row][col] = currentPlayer
        }
    }
    
    func reset() {
        currentPlayer = .cross
        board = [
            [.none, .none, .none],
            [.none, .none, .none],
            [.none, .none, .none]
        ]
        numMoves = 0
    }
}
