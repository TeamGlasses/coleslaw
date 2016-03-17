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
  
  var isCurrentPlayer: Bool {
    return game.currentPlayer.id == localPlayer.id
  }
  
  var isOnCurrentTeam: Bool {
    return game.currentPlayer.team.id == localPlayer.team.id
  }
  
  var game: Game! {
    didSet {
      NSNotificationCenter.defaultCenter().postNotificationName(GameUpdatedNotification, 	object: self, userInfo: nil)
    }
  }
  
  var localPlayer: Player!
  
  var session: SessionManager!
  
  var localColor: UIColor {
    return localPlayer.team.color
  }
}