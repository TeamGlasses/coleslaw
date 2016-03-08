//
//  Turn.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Turn: NSObject {
    var completedCards: [Card]?
    var activePlayer: Player?  // Can get Team via player.
    var timeRemaining: Int? = 60
}
