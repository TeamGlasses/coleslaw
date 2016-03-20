//
//  RoundViewController.swift
//  coleslaw
//
//  Created by Max Pappas on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RoundViewController: UIViewController {

  var statusView: StatusView!

  @IBOutlet var infoView: InfoView!
  @IBOutlet var startButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = LocalGameManager.sharedInstance.localColor

    statusView = StatusView()
    // Set statusView game for the first time.
    statusView.game = LocalGameManager.sharedInstance.game
    statusView.translatesAutoresizingMaskIntoConstraints = false
    statusView.renderInView(view)
    
    // view background
    view.backgroundColor = LocalGameManager.sharedInstance.localColor
    
    //button
    startButton.layer.cornerRadius = 16
    startButton.clipsToBounds = true
    startButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    startButton.titleLabel!.textAlignment = NSTextAlignment.Center
    startButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 40)

    // info view
    infoView.layer.cornerRadius = 16
    infoView.clipsToBounds = true
    infoView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    infoView.rulesLabel.textAlignment = NSTextAlignment.Center
    infoView.rulesLabel.font = UIFont(name: "SFUIDisplay-Medium", size: 24)
  }
  
  override func viewWillAppear(animated: Bool) {
    LocalGameManager.sharedInstance.session.delegate = self

    let isOwner = LocalGameManager.sharedInstance.session.isOwner
    startButton.hidden = !isOwner
    startButton.enabled = isOwner
    startButton.setTitle("Start Round \(LocalGameManager.sharedInstance.game.currentRoundIndex+2)", forState: .Normal)

    infoView.roundType = RoundType(rawValue: LocalGameManager.sharedInstance.game.currentRoundIndex + 1)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onStartRound(sender: AnyObject) {
    let game = LocalGameManager.sharedInstance.game
    
    let newRound = Round(toGuessCards: game.allCards, roundTypeRawValue: game.currentRoundIndex + 1, game: game)
    game.rounds.append(newRound)
    
    LocalGameManager.sharedInstance.session.broadcast("startRound", value: game)
    performSegueWithIdentifier("onRoundStart", sender: self)
  }
}

extension RoundViewController: SessionManagerDelegate {
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {
    let message = data["message"] as! String

    if message == "startRound" {
      let game = data["value"] as! Game
      LocalGameManager.sharedInstance.game = game
      performSegueWithIdentifier("onRoundStart", sender: self)
    }
  }

  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {}
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {}
}
