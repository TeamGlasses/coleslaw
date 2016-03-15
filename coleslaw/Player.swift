//
//  Player.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Player: NSObject, NSCoding {
  var id: Int
  var team: Team

  init(id: Int, team: Team) {
    self.id = id
    self.team = team
  }

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(id, forKey: "id")
    aCoder.encodeObject(team, forKey: "team")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeIntegerForKey("id")
    let team = aDecoder.decodeObjectForKey("team") as! Team
    self.init(id: id, team: team)
  }
}