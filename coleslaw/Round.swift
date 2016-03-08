//
//  Round.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

enum RoundType {
    case Regular, Acting, OneWord
}

class Round: NSObject {
    var currentTurn: Turn?
    var toGuessCards: [Card]?
    var completedCards: [Card]?
    var type: RoundType?
    var turns: [Turn]?

    // TODO: add computed properties for team scores.
}
