//
//  Team.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation
import UIKit

class Team: NSObject, NSCoding {
  var id: Int
  var name: String
  var color: UIColor

  init(id: Int, name: String, color: UIColor) {
    self.id = id
    self.name = name
    self.color = color
  }

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeInteger(id, forKey: "id")
    aCoder.encodeObject(name, forKey: "name")
    aCoder.encodeObject(color, forKey: "color")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let id = aDecoder.decodeIntegerForKey("id")
    let name = aDecoder.decodeObjectForKey("name") as! String
    let color = aDecoder.decodeObjectForKey("color") as! UIColor
    self.init(id: id, name: name, color: color)
  }

}
