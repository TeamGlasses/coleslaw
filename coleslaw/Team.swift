//
//  Team.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation



class Team: NSObject, NSCoding {
  var id: Int
  var name: String

  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(id, forKey: "id")
    aCoder.encodeObject(name, forKey: "name")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeIntegerForKey("id")
    let name = aDecoder.decodeObjectForKey("name") as! String
    self.init(id: id, name: name)
  }

}
