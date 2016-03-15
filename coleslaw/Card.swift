//
//  Card.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Card: NSObject, NSCoding {
  var title: String
  
  init(title: String){
    self.title = title
  }

  func toDict() -> [String: String] {
    return ["title": title]
  }

  // MARK: NSCoding
  // See https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(title, forKey: "title")
  }

  required convenience init?(coder aDecoder: NSCoder) {
    let title = aDecoder.decodeObjectForKey("title") as! String
    self.init(title: title)
  }

}
