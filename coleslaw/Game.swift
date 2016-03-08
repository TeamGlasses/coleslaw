//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Game: NSObject {
    var allCards: [Card]?
//  var scores: [Int]? // TODO: change to computed property
    var teams: [Team]?
    var allPlayers: [Player]?
    var rounds: [Round]?
    var currentRound: Round?
}
