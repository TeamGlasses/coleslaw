//
//  GameState.swift
//  coleslaw
//
//  Created by Max Pappas on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class GameState: NSObject {
  var cards: [Card]!
  var scores: [Int]!
  var teams: [String]!
  var currentRound: Int!
  var currentTeam: Int!
  let gameTime = 5
  var currentTime: Int!
  
  init(cards: [Card]) {
    self.cards = cards
    scores = [0, 0]
    currentRound = 1
    currentTeam = 0
    teams = ["Red", "Blue"]
    currentTime = gameTime
  }
  
  func switchTeams() {
    if (self.currentTeam == 0) {
      self.currentTeam = 1
    } else {
      self.currentTeam = 0
    }
  }
  
  func updateCurrentTeamScore() {
    return self.scores[self.currentTeam] = self.scores[self.currentTeam] + 1
  }
  
  func updateTimer() {
    self.currentTime = self.currentTime - 1
  }
  
  func updateRound() {
    self.currentRound = self.currentRound + 1
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
