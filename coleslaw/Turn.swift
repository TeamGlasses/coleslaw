//
//  Turn.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Turn: NSObject, NSCoding {
  var completedCards: [Card] = []
  var activePlayer: Player  // Can get Team via player.

  // Initializer used to create initial turn.
  init(activePlayer: Player) {
    self.activePlayer = activePlayer
  }

  // Initializer used by the decoder.
  init(completedCards: [Card], activePlayer: Player) {
    self.completedCards = completedCards
    self.activePlayer = activePlayer
  }

  var currentTeamIndex: Int {
    return activePlayer.team.id
  }

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(completedCards, forKey: "completedCards")
    aCoder.encodeObject(activePlayer, forKey: "activePlayer")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let completedCards = aDecoder.decodeObjectForKey("completedCards") as! [Card]
    let activePlayer = aDecoder.decodeObjectForKey("activePlayer") as! Player
    self.init(completedCards: completedCards, activePlayer: activePlayer)
  }
}
