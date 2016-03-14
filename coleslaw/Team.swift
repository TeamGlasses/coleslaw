//
//  Team.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Team: NSObject {
  var id: Int
  var name: String

  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}
