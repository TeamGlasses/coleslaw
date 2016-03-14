//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Game: NSObject {

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

  init(allCards: [Card], allTeams: [Team], allPlayers: [Player]) {
    self.allCards = allCards
    self.allTeams = allTeams
    self.allPlayers = allPlayers
  }
}
