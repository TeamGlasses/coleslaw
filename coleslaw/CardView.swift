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
  @IBOutlet weak var imageView: UIImageView!

  @IBOutlet weak var rightConstraint: NSLayoutConstraint!
  @IBOutlet weak var leftConstraint: NSLayoutConstraint!
  
  let animationDuration: NSTimeInterval = 0.3
  
  var delegate: CardViewDelegate!
  var card: Card!
  
  var isDraggingFromBottom: Bool!
  var cardTransform: CGAffineTransform!
  
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
    let nib = UINib(nibName: "CardView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    addSubview(contentView)
    
    bindPan()
  }
  
  func bindPan(){
    let recognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
    contentView.addGestureRecognizer(recognizer)
  }

  func onPan(sender: UIPanGestureRecognizer){
    let translation = sender.translationInView(contentView)
    let velocity = sender.velocityInView(contentView)
    
    if sender.state == UIGestureRecognizerState.Began {
      cardTransform = imageView.transform
      isDraggingFromBottom = sender.locationInView(contentView).y > (imageView.frame.height / 2)
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
    leftConstraint.constant = amount
    rightConstraint.constant = (-1 * amount)
    
    if withRotation {
      let ratio = amount / contentView.frame.width
      var angle = ratio * CGFloat(M_PI / 4.0)
      
      if isDraggingFromBottom == true {
        angle *= -1
      }
      
      imageView.transform = CGAffineTransformRotate(cardTransform, angle)
    }
  }
  
  func translateViewWithAnimation(amount: CGFloat, withRotation: Bool){
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      self.translateView(amount, withRotation: withRotation)
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
