//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, CardViewDelegate {

//  var cards: [Card]!
  var activeCard: CardView?
  
  let cardMargin = CGFloat(8)
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    cards = [
//      Card(title: "Barack Obama"),
//      Card(title: "Mt. Everest"),
//    ]
    
//    addActiveCardView(cards.first!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func cardViewAdvanced(cardView: CardView) {
    print("card view was advanced")
  }
  
  func cardViewDismissed(cardView: CardView) {
    print("card view was dismissed")
  }
  
  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
  
//  func addActiveCardView(card: Card){
//    let cardView = CardView()
//    cardView.translatesAutoresizingMaskIntoConstraints = false
//    cardView.card = card
//    cardView.delegate = self
//    
//    view.addSubview(cardView)
//
//    cardView.constraints
//    let views = ["cardView": cardView]
//    
//    var constraints = [NSLayoutConstraint]()
//    
//    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//      "V:[cardView(300)]-|", options: [], metrics: nil, views: views)
//    constraints += verticalConstraints
//
//    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
//      "H:|-[cardView]-|", options: [], metrics: nil, views: views)
//    constraints += horizontalConstraints
//  
//    NSLayoutConstraint.activateConstraints(constraints)
//  }
}

