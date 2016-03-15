//
//  Test.swift
//  coleslaw
//
//  Created by Michael Bock on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class Test: NSObject, NSCoding {
  var val: String = ""

  init(val: String) {
    self.val = val
  }

  required init?(coder aDecoder: NSCoder) {
    super.init()
    self.val = aDecoder.decodeObjectForKey("val") as! String
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(val, forKey: "val")
  }
}
