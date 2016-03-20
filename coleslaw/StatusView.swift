//
//  StatusView.swift
//  coleslaw
//
//  Created by Max Pappas on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class StatusView: UIView {

  let labelTag = 1
  let heightConstraintIdentifier = "heightConstraint"
  let widthConstraintIdentifier = "widthConstraint"
  
  @IBOutlet var teamAScoreLabel: UILabel!
  @IBOutlet var teamBScoreLabel: UILabel!
  @IBOutlet var teamAScoreView: UIView!
  @IBOutlet var teamBScoreView: UIView!
  @IBOutlet var contentView: UIView!
  
  @IBOutlet var teamAWidth: NSLayoutConstraint!
  @IBOutlet var teamAHeight: NSLayoutConstraint!
  @IBOutlet var teamABottom: NSLayoutConstraint!
  
  @IBOutlet var teamBWidth: NSLayoutConstraint!
  @IBOutlet var teamBHeight: NSLayoutConstraint!
  @IBOutlet var teamBBottom: NSLayoutConstraint!
  
  var smallFontSize: CGFloat!
  var largeFontSize: CGFloat!
  
  var smallWidth: CGFloat!
  var largeWidth: CGFloat!
  
  var smallHeight: CGFloat!
  var largeHeight: CGFloat!
  
  var game: Game! {
    didSet {
      updateStatus()
    }
  }
  
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
    
    smallFontSize = teamAScoreLabel.font.pointSize
    largeFontSize = teamBScoreLabel.font.pointSize
    
    smallWidth = teamAWidth.constant
    largeWidth = teamBWidth.constant
    
    smallHeight = teamAHeight.constant
    largeHeight = teamBHeight.constant
    
    NSNotificationCenter.defaultCenter().addObserverForName(GameUpdatedNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {(notification: NSNotification!) -> () in
      self.game = LocalGameManager.sharedInstance.game
    })
    
    scoreLabels = [teamAScoreLabel, teamBScoreLabel]
  }
  
  func renderInView(parentView: UIView) {
    parentView.addSubview(self)

    setupView(parentView)
    
    let topConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: (1/4), constant: 1.0)
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
    teamAScoreView.clipsToBounds = true
    teamBScoreView.clipsToBounds = true
    
    roundScoreViewCorners()
  }

  func updateStatus() {
    if game.currentPlayer.team == game.allTeams[0] {
      expandScoreLabel(teamAScoreView)
      contractScoreLabel(teamBScoreView)
      delayedRoundCorners()
    } else {
      expandScoreLabel(teamBScoreView)
      contractScoreLabel(teamAScoreView)
      delayedRoundCorners()
    }

    updateScores()
  }
  
  func delayedRoundCorners(){
    NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "roundScoreViewCorners", userInfo: nil, repeats: false)
  }
  
  func updateScores(){
    teamAScoreLabel.text = "\(game.scores[0])"
    teamBScoreLabel.text = "\(game.scores[1])"
  }
  
  func roundScoreViewCorners(){
    let cornerRadius = CGFloat(8.0)
    
    roundCorner(teamAScoreView, corner: [.BottomLeft, .BottomRight], radius: cornerRadius)
    roundCorner(teamBScoreView, corner: [.BottomLeft, .BottomRight], radius: cornerRadius)
  }
  
  func roundCorner(view: UIView, corner: UIRectCorner, radius: CGFloat){
    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.CGPath
    view.layer.mask = mask
  }
  
  func unroundCorners(){
    teamAScoreView.layer.mask = nil
    teamBScoreView.layer.mask = nil
  }
  
  func isExpanded(view: UIView) -> Bool {
    for c in view.constraints {
      if c.identifier == heightConstraintIdentifier {
        print("Got the constant")
        return c.constant == largeHeight!
      }
    }
    
    return false
  }
  
  func expandScoreLabel(view: UIView){
    updateScoreViewSizes(view, withFontSize: largeFontSize, height: largeHeight, width: largeWidth)
  }
  
  func contractScoreLabel(view: UIView){
    updateScoreViewSizes(view, withFontSize: smallFontSize, height: smallHeight, width: smallWidth)
  }

  func updateScoreViewSizes(scoreView: UIView, withFontSize fontSize: CGFloat, height: CGFloat, width: CGFloat){
    if let label = scoreView.viewWithTag(labelTag) as? UILabel {
      label.font = fontWithSize(fontSize)
    }
    
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    
    for c in scoreView.constraints {
      if c.identifier == heightConstraintIdentifier {
        heightConstraint = c
      } else if c.identifier == widthConstraintIdentifier {
        widthConstraint = c
      }
    }
    
    heightConstraint.constant = height
    widthConstraint.constant = width
  }
  
  func fontWithSize(size: CGFloat) -> UIFont {
    return UIFont(name: "SFUIText-Semibold", size: size)!
  }
}
