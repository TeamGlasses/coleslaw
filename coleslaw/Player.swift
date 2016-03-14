//
//  Player.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

struct Player {
  var id: Int
  var team: Team

  init(id: Int, team: Team) {
    self.id = id
    self.team = team
  }
}