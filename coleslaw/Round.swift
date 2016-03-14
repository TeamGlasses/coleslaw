//
//  Round.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

enum RoundType: Int {
  case Regular, Acting, OneWord
}

class Round {
  var lastCardIndex = 0
  var toGuessCards: [Card]
  var roundType: RoundType
  var game: Game
  var turns: [Turn] = []

  var randomCard: Card {
    get {
      if toGuessCards.count == 1 {
        lastCardIndex = 0
        return toGuessCards[0]
      } else {
        var randomIndex = Int(arc4random_uniform(UInt32(toGuessCards.count)))
        while randomIndex == lastCardIndex {
          randomIndex = Int(arc4random_uniform(UInt32(toGuessCards.count)))
        }
        lastCardIndex = randomIndex
        return toGuessCards[randomIndex]
      }
    }
  }

  var currentTurnIndex: Int {
    get {
      return turns.count - 1
    }
  }

  var currentTurn: Turn {
    get {
      return turns[currentTurnIndex]
    }
  }

  var isOver: Bool {
    get {
      return toGuessCards.isEmpty
    }
  }

  var roundIndexInGame: Int {
    var result = -1
    for (index, round) in game.rounds.enumerate() {
      if round.roundType == self.roundType {
        result = index
      }
    }
    return result
  }

  // Returns an array where the index is the team id and the value is the team's score.
  var scores: [Int] {
    get {
      var scores = [Int](count: 2, repeatedValue: 0)
      for turn in turns {
        scores[turn.currentTeamIndex] += turn.completedCards.count
      }
      return scores
    }
  }

  var winner: Team {
    let localScores = scores
    return game.allTeams[localScores.indexOf(localScores.maxElement()!)!]
  }

  init(toGuessCards: [Card], roundTypeRawValue: Int, game: Game) {
    self.toGuessCards = toGuessCards
    self.roundType = RoundType(rawValue: roundTypeRawValue)!
    self.game = game
  }
}
