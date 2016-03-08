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
  var toGuessCards: [Card]
  var roundType: RoundType
  var turns: [Turn] = []

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

  init(toGuessCards: [Card], roundTypeRawValue: Int) {
    self.toGuessCards = toGuessCards
    self.roundType = RoundType(rawValue: roundTypeRawValue)!
  }
}
