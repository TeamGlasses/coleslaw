//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

@objc protocol GameDelegate {
//  optional func game(game: Game, turnDidStart turn: Turn)
//
//  optional func game(game: Game, roundDidStart round: Round)

  optional func gameTurnDidStart(game: Game)
  optional func gameTurnDidEnd(game: Game)
  optional func gameRoundDidEnd(game: Game)
  optional func gameDidEnd(game: Game)
}

class Game: NSObject, NSCoding {
  // Real properties.
  var delegate: GameDelegate!
  var allCards: [Card]
  var allTeams: [Team]
  var allPlayers: [Player]
  var currentPlayerIndex: Int = 0 {
    didSet {
      if currentPlayerIndex == allPlayers.count {
        currentPlayerIndex = 0
      }
    }
  }
  var rounds: [Round] = []
  // End real properties.

  // Initializer used to create initial game.
  init(allCards: [Card], allTeams: [Team], allPlayers: [Player]) {
    self.allCards = allCards
    self.allTeams = allTeams
    self.allPlayers = allPlayers
  }

  // Initializer used by decoder.
  init(allCards: [Card], allTeams: [Team], allPlayers: [Player], currentPlayerIndex: Int, rounds: [Round]) {
    self.allCards = allCards
    self.allTeams = allTeams
    self.allPlayers = allPlayers
    self.currentPlayerIndex = currentPlayerIndex
    self.rounds = rounds
  }

  // Only computed properties below.
  var currentRoundIndex: Int {
    get {
      return rounds.count-1
    }
  }

  var currentRound: Round {
    get {
      return rounds[currentRoundIndex]
    }
  }
  
  var currentPlayer: Player {
    return allPlayers[currentPlayerIndex]
  }

  // Returns an array where the index is the team id and the value is the team's score.
  var scores: [Int] {
    var scores = [Int](count: 2, repeatedValue: 0)
    for round in rounds {
      for (index, score) in round.scores.enumerate() {
        scores[index] += score
      }
    }
    return scores
  }

  var winner: Team {
    let localScores = scores
    return allTeams[localScores.indexOf(localScores.maxElement()!)!]
  }

  var isOver: Bool {
    get {
      return rounds.count == 3
    }
  }
  // End computed properties.

  func turnStart() {
    let newTurn = Turn(activePlayer: allPlayers[currentPlayerIndex])
    rounds[currentRoundIndex].turns.append(newTurn)
    
    delegate.gameTurnDidStart!(self)
    LocalGameManager.sharedInstance.session.broadcast("turnStart", value: self)
  }
  
  func turnEnd(){
    currentPlayerIndex += 1
    
    if currentRound.isOver {
      roundEnd()
    } else {
      delegate.gameTurnDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("turnEnd", value: self)
    }
  }
  
  func roundEnd(){
    if isOver {
      delegate.gameDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("gameEnd", value: self)
    } else {
      delegate.gameRoundDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("roundEnd", value: self)
    }
  }
  
  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(allCards, forKey: "allCards")
    aCoder.encodeObject(allTeams, forKey: "allTeams")
    aCoder.encodeObject(allPlayers, forKey: "allPlayers")
    aCoder.encodeInteger(currentPlayerIndex, forKey: "currentPlayerIndex")
    aCoder.encodeObject(rounds, forKey: "rounds")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let allCards = aDecoder.decodeObjectForKey("allCards") as! [Card]
    let allTeams = aDecoder.decodeObjectForKey("allTeams") as! [Team]
    let allPlayers = aDecoder.decodeObjectForKey("allPlayers") as! [Player]
    let currentPlayerIndex = aDecoder.decodeIntegerForKey("currentPlayerIndex")
    let rounds = aDecoder.decodeObjectForKey("rounds") as! [Round]
    self.init(allCards: allCards, allTeams: allTeams, allPlayers: allPlayers, currentPlayerIndex: currentPlayerIndex, rounds: rounds)
  }
}
