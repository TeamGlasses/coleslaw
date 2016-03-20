//
//  InfoView.swift
//  coleslaw
//
//  Created by Michael Bock on 3/16/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

let RULES_STRINGS: [RoundType: String] = [
  RoundType.Regular: "In this round you can say anything to help your team guess the clue! " +
    "Swipe right for yes and left to pass.",
  RoundType.Acting: "In this round you must act out the clue without saying any words!",
  RoundType.OneWord: "In this round you can only say one word to help your team guess the clue!"
]

class InfoView: UIView {
  @IBOutlet weak var rulesLabel: UILabel!

  var roundType: RoundType! {
    didSet {
      rulesLabel.lineBreakMode = .ByWordWrapping
      rulesLabel.numberOfLines = 7
      rulesLabel.text = RULES_STRINGS[roundType]
    }
  }
}
