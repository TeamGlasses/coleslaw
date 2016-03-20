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

  @IBOutlet var passImageView: UIImageView!
  @IBOutlet var checkImageView: UIImageView!
  
  let animationDuration: NSTimeInterval = 0.2
  
  var delegate: CardViewDelegate!
  var card: Card!
  
  var isDraggingFromBottom: Bool!
  var cardTransform: CGAffineTransform!
  
  var centerConstraint: NSLayoutConstraint!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initSubviews()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initSubviews()
    
    titleLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 50)
    titleLabel.textColor = UIColor(red: 56.0/255.0, green: 56.0/255.0, blue: 56.0/255.0, alpha: 1)
    titleLabel.minimumScaleFactor = 30 / titleLabel.font.pointSize;
  }
  
  func renderFakeCard(parentView: UIView, multiplier: CGFloat, bottomOffset: CGFloat) {
    titleLabel.text = ""
    parentView.addSubview(self)
    
    let topConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: parentView, attribute: .Height, multiplier: (1/2), constant: 1.0)
    topConstraint.priority = UILayoutPriorityDefaultHigh
    topConstraint.active = true
    
    let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: parentView, attribute: .Bottom, multiplier: 1.0, constant: bottomOffset)
    bottomConstraint.priority = UILayoutPriorityDefaultHigh
    bottomConstraint.active = true
    
    let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: parentView, attribute: .Width, multiplier: multiplier, constant: 0)
    widthConstraint.priority = UILayoutPriorityDefaultHigh
    widthConstraint.active = true
    
    centerConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: parentView, attribute: .CenterX, multiplier: 1.0, constant: 0)
    centerConstraint.priority = UILayoutPriorityDefaultHigh
    centerConstraint.active = true
    
    unbindPan()
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
  }
  
  func initSubviews() {
    // standard initialization logic
    let nib = UINib(nibName: "CardView", bundle: nil)
    nib.instantiateWithOwner(self, options: nil)
    contentView.frame = bounds
    contentView.layer.cornerRadius = 16
    contentView.layer.shadowOpacity = 0.2
    contentView.layer.shadowOffset = CGSizeMake(0, 0)
    contentView.layer.shadowRadius = 16
    contentView.layer.shadowColor = UIColor.blackColor().CGColor
    contentView.layer.masksToBounds = false
    contentView.clipsToBounds = false
    addSubview(contentView)
    
    bindPan()
  }
  
  func bindPan() {
    let recognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
    contentView.addGestureRecognizer(recognizer)
  }
  
  func unbindPan() {
    contentView.gestureRecognizers?.forEach(contentView.removeGestureRecognizer)
  }


  func onPan(sender: UIPanGestureRecognizer){
    
    let translation = sender.translationInView(contentView.superview!)
    let velocity = sender.velocityInView(contentView.superview!)
    let location = sender.locationInView(contentView.superview!)
    
    if sender.state == UIGestureRecognizerState.Began {
      cardTransform = contentView.transform
      isDraggingFromBottom = location.y > (contentView.frame.height / 2)
    } else if sender.state == UIGestureRecognizerState.Changed {
      translateView(translation.x, withRotation: true, cardComplete: false)
      
      checkImageView.image = UIImage(named: "checkmark-inactive")
      passImageView.image = UIImage(named: "x-inactive")
      
      if (translation.x > 0) {
        checkImageView.image = UIImage(named: "checkmark-active")
      } else {
        passImageView.image = UIImage(named: "x-active")
      }
    } else if sender.state == UIGestureRecognizerState.Ended {

      if isAdvanceable(velocity, translation: translation) {
        // Card was swiped right
        translateViewWithAnimation(2 * contentView.frame.width, withRotation: true, cardComplete: true, callback: delegate.cardViewAdvanced)
      } else if isDismissable(velocity, translation: translation){
        // Card was swiped left
        translateViewWithAnimation(-2 * contentView.frame.width, withRotation: true, cardComplete: true, callback: delegate.cardViewDismissed)
      } else {
        // Card wasn't swiped enought to count as advancing or dismissal
        translateViewWithAnimation(0, withRotation: false, cardComplete: false, callback: nil)
        checkImageView.image = UIImage(named: "checkmark-inactive")
        passImageView.image = UIImage(named: "x-inactive")
      }
    }
  }
  
  func translateView(amount: CGFloat, withRotation: Bool, cardComplete: Bool){
    centerConstraint.constant = amount
    
    if withRotation {
      let ratio = amount / contentView.frame.width
      var angle = ratio * CGFloat(M_PI / 4.0)
      
      if isDraggingFromBottom == true {
        angle *= -1
      }
      
      contentView.transform = CGAffineTransformRotate(cardTransform, angle)
    } else {
      contentView.transform = CGAffineTransformIdentity
    }
  }
  
  func translateViewWithAnimation(amount: CGFloat, withRotation: Bool, cardComplete: Bool, callback: ((CardView) -> ())?){
    self.contentView.superview!.layoutIfNeeded()
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      self.translateView(amount, withRotation: withRotation, cardComplete: cardComplete)
      self.contentView.superview!.superview!.layoutIfNeeded()
    }, completion: { (_: Bool) -> Void in
      self.delegate.cardViewFinishedAnimating(self)
      if callback != nil {
        callback!(self)
      }
    })
  }
  
  func isAdvanceable(velocity: CGPoint, translation: CGPoint) -> Bool {
    return velocity.x > 0 && translation.x > 50
  }
  
  func isDismissable(velocity: CGPoint, translation: CGPoint) -> Bool {
    return velocity.x < 0 && translation.x < -50
  }
}
