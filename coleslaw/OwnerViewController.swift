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
  
  @IBOutlet weak var connectionsLabel: UIButton!
  @IBOutlet weak var dismissButton: UIButton!
  
  var session = OwnerSessionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    session.delegate = self
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func onStartGame(sender: UIButton) {
    print("Starting game...")
  }
  
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {
    dispatch_async(dispatch_get_main_queue()){
      self.connectionsLabel.titleLabel!.text = "\(self.session.peers.count)"
    }
  }
  
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {}
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {}
}
