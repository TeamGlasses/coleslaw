//
//  RoundViewController.swift
//  coleslaw
//
//  Created by Max Pappas on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RoundViewController: UIViewController, SessionManagerDelegate {

  var statusView: StatusView!

  @IBOutlet var infoView: UIView!
  @IBOutlet var startButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = LocalGameManager.sharedInstance.localColor

    statusView = StatusView()
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

    let isOwner = LocalGameManager.sharedInstance.session.isOwner
    startButton.hidden = !isOwner
    startButton.enabled = isOwner
  }
  
  override func viewWillAppear(animated: Bool) {
    LocalGameManager.sharedInstance.session.delegate = self
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
