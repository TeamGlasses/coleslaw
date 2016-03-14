//
//  StatusView.swift
//  coleslaw
//
//  Created by Max Pappas on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class StatusView: UIView {

  @IBOutlet var teamAScoreLabel: UILabel!
  @IBOutlet var teamBScoreLabel: UILabel!
  @IBOutlet var roundLabel: UILabel!
  @IBOutlet var roundView: UIView!
  @IBOutlet var teamAScoreView: UIView!
  @IBOutlet var teamBScoreView: UIView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var teamAWidth: NSLayoutConstraint!
  @IBOutlet var teamAHeight: NSLayoutConstraint!
  @IBOutlet var teamABottom: NSLayoutConstraint!
  
  @IBOutlet var teamBWidth: NSLayoutConstraint!
  @IBOutlet var teamBHeight: NSLayoutConstraint!
  @IBOutlet var teamBBottom: NSLayoutConstraint!
  
  var game: Game! {
    didSet {
      updateStatus()
    }
  }
  
  var currentPlayerIndex : Int?
  var scoreLabels: [UILabel]!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
  }
  
  func initSubviews() {
    // standard initialization logic
    let nib = UINib(nibName: "StatusView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
    
    scoreLabels = [teamAScoreLabel, teamBScoreLabel]
  }
  
  func renderInView(parentView: UIView) {
    parentView.addSubview(self)

    setupView(parentView)
    
    let topConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: (1/2), constant: 1.0)
    topConstraint.priority = UILayoutPriorityDefaultHigh
    topConstraint.active = true
    
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: parentView, attribute: .Width, multiplier: 1.0, constant: 0)
    widthConstraint.priority = UILayoutPriorityDefaultHigh
    widthConstraint.active = true
    
    let centerConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: parentView, attribute: .CenterX, multiplier: 1.0, constant: 0)
    centerConstraint.priority = UILayoutPriorityDefaultHigh
    centerConstraint.active = true
  }
  
  func setupView(parentView: UIView) {
    let roundGradient = CAGradientLayer()
    roundGradient.frame = roundView.bounds

    var newFrame = roundGradient.frame
    newFrame.origin.y = newFrame.origin.y + 10; // add 100 to y's current value
    newFrame.size.width = parentView.frame.size.width
    roundGradient.frame = newFrame;

    roundGradient.colors = [UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1).CGColor, UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1).CGColor]
    roundGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
    roundGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
    roundView.layer.insertSublayer(roundGradient, atIndex: 0)
    roundView.layer.cornerRadius = 10.0
    roundView.clipsToBounds = true
    roundLabel.textColor = UIColor.whiteColor()
    roundLabel.font = UIFont(name: "SFUIText-Semibold", size: 15)
    
    teamAScoreView.layer.cornerRadius = 8.0
    teamBScoreView.layer.cornerRadius = 8.0
    teamAScoreView.clipsToBounds = true
    teamBScoreView.clipsToBounds = true
    teamAScoreLabel.font = UIFont(name: "SFUIText-Semibold", size: 15)
    teamBScoreLabel.font = UIFont(name: "SFUIText-Semibold", size: 21)
  }

  func updateStatus() {
    if currentPlayerIndex != game.currentPlayerIndex {
      currentPlayerIndex = game.currentPlayerIndex
      
      let currentPlayer = game.allPlayers[game.currentPlayerIndex]
      let nextTeam = currentPlayer.team
      var nextScoreLabel = teamAScoreLabel
      var nextScoreWidth = teamAWidth
      var nextScoreHeight = teamAHeight
      var nextScoreBottom = teamABottom
      
      var prevScoreLabel = teamBScoreLabel
      var prevScoreWidth = teamBWidth
      var prevScoreHeight = teamBHeight
      var prevScoreBottom = teamBBottom
      
      // switch up the score sizes
      if (nextTeam.id == 1) {
        nextScoreLabel = teamBScoreLabel
        nextScoreWidth = teamBWidth
        nextScoreHeight = teamBHeight
        nextScoreBottom = teamBBottom
        
        prevScoreLabel = teamAScoreLabel
        prevScoreWidth = teamAWidth
        prevScoreHeight = teamAHeight
        prevScoreBottom = teamABottom
      }
    
      
      let tempScoreWidthConstant = nextScoreWidth.constant
      nextScoreWidth.constant = prevScoreWidth.constant
      prevScoreWidth.constant = tempScoreWidthConstant
      
      let tempScoreHeightConstant = nextScoreHeight.constant
      nextScoreHeight.constant = prevScoreHeight.constant
      prevScoreHeight.constant = tempScoreHeightConstant
      
      let tempScoreBottomConstraint = nextScoreBottom.constant
      nextScoreBottom.constant = prevScoreBottom.constant
      prevScoreBottom.constant = tempScoreBottomConstraint
      
      let tempFontSize = nextScoreLabel.font.pointSize
      nextScoreLabel.font = nextScoreLabel.font.fontWithSize(prevScoreLabel.font.pointSize)
      prevScoreLabel.font = prevScoreLabel.font.fontWithSize(tempFontSize)
    }
  }

}
