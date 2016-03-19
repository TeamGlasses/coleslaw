//
//  ViewController.swift
//  MCTest
//
//  Created by Jack Kearney on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MBProgressHUD

class OwnerViewController: UIViewController, SessionManagerDelegate {
  
  @IBOutlet weak var connectionsLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!

  var allCards: [Card]!
  
  var session = OwnerSessionManager()
  
  var allowSoloPlay = true
  
  override func viewDidLoad() {
    super.viewDidLoad()

    startButton.enabled = false
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    FirebaseClient.sharedInstance.getCards("demo") { (cards: [Card]!) -> Void in
      self.allCards = cards
      self.startButton.enabled = true
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    session.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  func createGameAndBroadcast() {
    let game = Game.createGame(withCards: allCards, andNumberOfPeers: session.peers.count)
    
    LocalGameManager.sharedInstance.game = game
    LocalGameManager.sharedInstance.localPlayer = game.ownerPlayer
    LocalGameManager.sharedInstance.session = session

    for (index, peer) in session.peers.enumerate() {
      var value = [String: AnyObject]()
      value["player"] = game.allPlayers[index]
      value["game"] = game

      session.sendMessage("assignPlayerAndGame", value: value, toPeer: peer)
    }
    
    session.stop()
  }
  
  @IBAction func onStartGame(sender: UIButton) {
    if allowSoloPlay || session.peers.count > 0 {
      createGameAndBroadcast()
      performSegueWithIdentifier("ownerStartGame", sender: self)
    } else {
      let alertController = UIAlertController(title: "Nobody connected!",
        message: nil,
        preferredStyle: .Alert)
      let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
      alertController.addAction(cancelAction)
      presentViewController(alertController, animated: true, completion: nil)
    }
  }
  
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {
    print(self.session.peers.count)
    dispatch_async(dispatch_get_main_queue()) {
      print(self.session.peers.count)
      self.connectionsLabel.text = "\(self.session.peers.count)"
    }
  }
  
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {}
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {}
}
