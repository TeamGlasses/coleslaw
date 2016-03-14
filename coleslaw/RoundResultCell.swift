//
//  RoundResultCell.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class RoundResultCell: UITableViewCell {
  @IBOutlet weak var roundNameLabel: UILabel!
  @IBOutlet weak var winnerAnnouncementLabel: UILabel!
  @IBOutlet weak var redScoreLabel: UILabel!
  @IBOutlet weak var blueScoreLabel: UILabel!

  var round: Round! {
    didSet {
      roundNameLabel.text = "Round #\(round.roundIndexInGame + 1)"
      winnerAnnouncementLabel.text = "Winner: \(round.winner.name)"
      let scores = round.scores
      redScoreLabel.text = "\(scores[0])"
      blueScoreLabel.text = "\(scores[1])"
    }
  }

}
