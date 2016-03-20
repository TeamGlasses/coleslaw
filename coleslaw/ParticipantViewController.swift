//
//  AdvertiseViewController.swift
//  MCTest
//
//  Created by Jack Kearney on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import MBProgressHUD

class ParticipantViewController: UIViewController {
  var session = ParticipantSessionManager()
  
  @IBOutlet weak var connectedView: UIView!

  @IBOutlet weak var lookingView: UIView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  let animationDuration = NSTimeInterval(0.5)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    session.delegate = self
//    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    activityIndicator.startAnimating()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
  func showConnected(){
//    MBProgressHUD.hideHUDForView(self.view, animated: true)
    activityIndicator.stopAnimating()
    lookingView.hidden = true
    connectedView.hidden = false
  }
  
  @IBAction func onDismiss(sender: AnyObject) {
    session.stop()
    dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ParticipantViewController: SessionManagerDelegate {
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {
    if thisSessionDidConnect {
      showConnected()
    }
  }

  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {
    showConnected()
  }

  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {
    let message = data["message"] as! String

    if message == "assignPlayerAndGame" {
      let value = data["value"] as! [String: AnyObject]
      let player = value["player"] as! Player
      let game = value["game"] as! Game

      LocalGameManager.sharedInstance.localPlayer = player
      LocalGameManager.sharedInstance.game = game
      LocalGameManager.sharedInstance.session = session

      session.stop()

      performSegueWithIdentifier("participantStartGame", sender: self)
    }
  }
}
