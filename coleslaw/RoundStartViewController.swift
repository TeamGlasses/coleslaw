//
//  RoundStartViewController.swift
//  coleslaw
//
//  Created by Michael Bock on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class RoundStartViewController: UIViewController {

  @IBOutlet weak var startRoundButton: UIButton!

  @IBOutlet weak var roundStartLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let numPlayers = LocalGameManager.sharedInstance.game.allPlayers.count
    
    view.backgroundColor = LocalGameManager.sharedInstance.localPlayer.team.color
  }
}
