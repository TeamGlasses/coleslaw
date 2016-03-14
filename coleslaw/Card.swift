//
//  Card.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

class Card {
  var title: String
  
  init(title: String){
    self.title = title
  }

  func toDict() -> [String: String] {
    return ["title": title]
  }
}
