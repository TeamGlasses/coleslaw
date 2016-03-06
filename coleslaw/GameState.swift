//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class GameState: NSObject {
  var scores: [Int]!
  var teams: [String]!
  var currentRound: Int!
  var currentTeam: Int!
  let gameTime = 60
  var currentTime: Int!
  
  override init() {
    scores = [0, 0]
    currentRound = 1
    currentTeam = 0
    teams = ["Red", "Blue"]
    currentTime = gameTime
  }
  
//  class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
////    var tweets = [Tweet]()
////    
////    for dictionary in array {
////      tweets.append(Tweet(dictionary: dictionary))
////    }
////    
////    return tweets
//  }
}
