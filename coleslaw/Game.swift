//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GameDelegate {
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
    return rounds.count-1
  }

  var currentRound: Round {
    return rounds[currentRoundIndex]
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
  
  var loser: Team {
    let localScores = scores
    return allTeams[localScores.indexOf(localScores.minElement()!)!]
  }

  var isOver: Bool {
    return rounds.count == 3
  }

  var ownerPlayer: Player {
    return allPlayers.last!
  }
  // End computed properties.

  func turnStart() {
    let newTurn = Turn(activePlayer: allPlayers[currentPlayerIndex])
    rounds[currentRoundIndex].turns.append(newTurn)
    
    delegate.gameTurnDidStart!(self)
    LocalGameManager.sharedInstance.session.broadcast("turnStart", value: self)
  }
  
  func turnEnd() {
    currentPlayerIndex += 1

    currentRound.currentTurn.isOver = true
    
    if currentRound.isOver {
      roundEnd()
    } else {
      delegate.gameTurnDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("turnEnd", value: self)
    }
  }
  
  func roundEnd() {
    if isOver {
      delegate.gameDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("gameEnd", value: self)
    } else {
      delegate.gameRoundDidEnd!(self)
      LocalGameManager.sharedInstance.session.broadcast("roundEnd", value: self)
    }
  }
  
  func completeCurrentCard(){
    currentRound.completeCurrentCard()
    LocalGameManager.sharedInstance.session.broadcast("gameUpdated", value: self)
    LocalGameManager.sharedInstance.triggerGameUpdate()
  }
  
  class func createGame(withCards cards: [Card], andNumberOfPeers count: Int) -> Game {
    var teamColors = [UIColor(red: 201.0/255.0, green: 56.0/255.0, blue: 87.0/255.0, alpha: 1), UIColor(red: 56.0/255.0, green: 126.0/255.0, blue: 201.0/255.0, alpha: 1)]

    let redTeam = Team(id: 0, name: "Team Red", color: teamColors[0])

    let blueTeam = Team(id: 1, name: "Team Blue", color: teamColors[1])

    let allTeams = [redTeam, blueTeam]

    var allPlayers = [Player]()

    for index in 0..<count {
      if index % 2 == 0 {
        allPlayers.append(Player(id: index, team: allTeams[0]))
      } else {
        allPlayers.append(Player(id: index, team: allTeams[1]))
      }
    }

    // Add owner to game
    let ownerIndex = count
    let ownerPlayer = Player(id: ownerIndex, team: allTeams[ownerIndex % 2])
    allPlayers.append(ownerPlayer)

    return Game(allCards: cards, allTeams: allTeams, allPlayers: allPlayers)
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
