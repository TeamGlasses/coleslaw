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

  @IBOutlet var loserScoreLabel: UILabel!
  @IBOutlet var winnerScoreLabel: UILabel!
  
  var gameWinner: Team!
  var gameLoser: Team!
  var isTied: Bool!

  var round: Round! {
    didSet {
      roundNameLabel.text = "Round \(round.roundIndexInGame + 1)"
      roundNameLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 18)
      //winnerAnnouncementLabel.text = "Winner: \(round.winner.name)"
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let scores = round.scores
    var loserFont = "SFUIDisplay-Light"
    
    if isTied == true {
      loserFont = "SFUIDisplay-Bold"
    }
    
    winnerScoreLabel.text = "\(scores[gameWinner.id])"
    loserScoreLabel.text = "\(scores[gameLoser.id])"
    
    winnerScoreLabel.textColor = gameWinner.color
    winnerScoreLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 36)
    
    loserScoreLabel.textColor = gameLoser.color
    loserScoreLabel.font = UIFont(name: loserFont, size: 36)
  }

}
