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

class Round: NSObject, NSCoding {
  // Real properties.
  var lastCardIndex = 0
  var toGuessCards: [Card]
  var roundType: RoundType
  var game: Game
  var turns: [Turn] = []
  // End real properties.

  // Initializer used to create initial round.
  init(toGuessCards: [Card], roundTypeRawValue: Int, game: Game) {
    self.toGuessCards = toGuessCards
    self.roundType = RoundType(rawValue: roundTypeRawValue)!
    self.game = game
  }

  // Initializer used by decoder.
  init(lastCardIndex: Int, toGuessCards: [Card], roundTypeRawValue: Int, game: Game, turns: [Turn]) {
    self.lastCardIndex = lastCardIndex
    self.toGuessCards = toGuessCards
    self.roundType = RoundType(rawValue: roundTypeRawValue)!
    self.game = game
    self.turns = turns
  }

  // Only computed properties below.
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
  // End computed properties.

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(lastCardIndex, forKey: "lastCardIndex")
    aCoder.encodeObject(toGuessCards, forKey: "toGuessCards")
    aCoder.encodeInteger(roundType.rawValue, forKey: "roundType.rawValue")
    aCoder.encodeObject(game, forKey: "game")
    aCoder.encodeObject(turns, forKey: "turns")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let lastCardIndex = aDecoder.decodeIntegerForKey("lastCardIndex")
    let toGuessCards = aDecoder.decodeObjectForKey("toGuessCards") as! [Card]
    let roundTypeRawValue = aDecoder.decodeIntegerForKey("roundType.rawValue")
    let game = aDecoder.decodeObjectForKey("game") as! Game
    let turns = aDecoder.decodeObjectForKey("turns") as! [Turn]
    self.init(lastCardIndex: lastCardIndex, toGuessCards: toGuessCards, roundTypeRawValue: roundTypeRawValue, game: game, turns: turns)
  }
}
