//
//  LocalGameManager.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/14/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation
import UIKit

class LocalGameManager {
  class var sharedInstance: LocalGameManager {
    struct Static {
      static let instance = LocalGameManager()
    }
    
    return Static.instance
  }
  
  func isCurrentPlayer(){
    game.currentPlayerIndex == localPlayer.id
  }
  
  var game: Game!
  
  var localPlayer: Player!
  
  var session: SessionManager!
  
  var localColor: UIColor {
    get {
      return localPlayer.team.color
    }
  }
}