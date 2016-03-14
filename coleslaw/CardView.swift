//
//  CardView.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
  func cardViewAdvanced(cardView: CardView)
  func cardViewDismissed(cardView: CardView)
  func cardViewFinishedAnimating(cardView: CardView)
}

class CardView: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  
  let animationDuration: NSTimeInterval = 0.3
  
  var delegate: CardViewDelegate!
  var card: Card!
  
  var isDraggingFromBottom: Bool!
  var cardTransform: CGAffineTransform!
  
//  var leftConstraint: NSLayoutConstraint!
//  var rightConstraint: NSLayoutConstraint!

  var centerConstraint: NSLayoutConstraint!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
    
    titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 60)
  }
  
  func renderInView(parentView: UIView){
    titleLabel.text = card.title
    
    parentView.addSubview(self)
    
    let topConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: (1/2), constant: 1.0)
    topConstraint.priority = UILayoutPriorityDefaultHigh
    topConstraint.active = true
    
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: parentView, attribute: .Bottom, multiplier: 1.0, constant: 0)
    bottomConstraint.priority = UILayoutPriorityDefaultHigh
    bottomConstraint.active = true

    let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: parentView, attribute: .Width, multiplier: 1.0, constant: 0)
    widthConstraint.priority = UILayoutPriorityDefaultHigh
    widthConstraint.active = true
    
    centerConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: parentView, attribute: .CenterX, multiplier: 1.0, constant: 0)
    centerConstraint.priority = UILayoutPriorityDefaultHigh
    centerConstraint.active = true
    
    //
//    leftConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: parentView, attribute: .Leading, multiplier: 1.0, constant: 8)
//    leftConstraint.priority = UILayoutPriorityDefaultHigh;
//    leftConstraint.active = true
//    
//    rightConstraint = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: parentView, attribute: .Trailing, multiplier: 1.0, constant: 8)
//    rightConstraint.priority = UILayoutPriorityDefaultHigh;
//    rightConstraint.active = true
    
//    parentView.layoutIfNeeded()
//    UIView.animateWithDuration(animationDuration * 10, animations: { () -> Void in
//      self.leftConstraint.constant = self.contentView.frame.size.width
//      self.rightConstraint.constant = -1 * self.contentView.frame.size.width
//
//      parentView.layoutIfNeeded()
//    }, completion: nil)
  }
  
  func initSubviews() {
    // standard initialization logic
    let nib = UINib(nibName: "CardView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    contentView.layer.cornerRadius = 16
    contentView.clipsToBounds = true
    addSubview(contentView)
    
    bindPan()
  }
  
  func bindPan(){
    let recognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
    contentView.addGestureRecognizer(recognizer)
  }

  func onPan(sender: UIPanGestureRecognizer){
    
    let translation = sender.translationInView(contentView.superview!)
    let velocity = sender.velocityInView(contentView.superview!)
    let location = sender.locationInView(contentView.superview!)
    
    if sender.state == UIGestureRecognizerState.Began {
      cardTransform = contentView.transform
      isDraggingFromBottom = location.y > (contentView.frame.height / 2)
    } else if sender.state == UIGestureRecognizerState.Changed {
      translateView(translation.x, withRotation: true)

    } else if sender.state == UIGestureRecognizerState.Ended {

      if isAdvanceable(velocity, translation: translation) {
        // Card was swiped right
        translateViewWithAnimation(2 * contentView.frame.width, withRotation: true)
        delegate.cardViewAdvanced(self)
      } else if isDismissable(velocity, translation: translation){
        // Card was swiped left
        translateViewWithAnimation(-2 * contentView.frame.width, withRotation: true)
        delegate.cardViewDismissed(self)
      } else {
        // Card wasn't swiped enought to count as advancing or dismissal
        translateViewWithAnimation(0, withRotation: false)
      }
    }
  }
  
  func translateView(amount: CGFloat, withRotation:Bool){
    centerConstraint.constant = amount
    
    if withRotation {
      let ratio = amount / contentView.frame.width
      var angle = ratio * CGFloat(M_PI / 4.0)
      
      if isDraggingFromBottom == true {
        angle *= -1
      }
      
      contentView.transform = CGAffineTransformRotate(cardTransform, angle)
    }
  }
  
  func translateViewWithAnimation(amount: CGFloat, withRotation: Bool){
    contentView.superview!.layoutIfNeeded()
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      self.translateView(amount, withRotation: withRotation)
      self.contentView.superview!.layoutIfNeeded()
    }, completion: { (_: Bool) -> Void in
      self.delegate.cardViewFinishedAnimating(self)
    })
  }
  
  func isAdvanceable(velocity: CGPoint, translation: CGPoint) -> Bool {
    return velocity.x > 0 && isActionablePanDistance(translation)
  }
  
  func isDismissable(velocity: CGPoint, translation: CGPoint) -> Bool {
    return velocity.x < 0 && isActionablePanDistance(translation)
  }
  
  func isActionablePanDistance(translation: CGPoint) -> Bool {
    return abs(translation.x) > 30
  }
}
