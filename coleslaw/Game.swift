//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Game {
  var allCards: [Card]
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

  var scores: [Int] {
    var scores = [Int](count: 2, repeatedValue: 0)
    for round in rounds {
      for turn in round.turns {
        scores[turn.currentTeamIndex] += turn.completedCards.count
      }
    }
    return scores
  }

  init(allCards: [Card], allPlayers: [Player]) {
    self.allCards = allCards
    self.allPlayers = allPlayers
  }

  //  var scores: [Int]? // TODO: change to computed property
}
