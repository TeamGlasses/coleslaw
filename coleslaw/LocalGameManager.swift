//
//  LocalGameManager.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/14/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class LocalGameManager {
  class var sharedInstance: LocalGameManager {
    struct Static {
      static let instance = LocalGameManager()
    }
    
    return Static.instance
  }
  
  func amCurrentPlayer(){
    game.currentPlayerIndex == localPlayer.id
  }
  
  var game: Game!
  var localPlayer: Player!
}