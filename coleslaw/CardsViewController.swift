//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, CardViewDelegate {

  @IBOutlet weak var card: CardView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    card.delegate = self
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
}

