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

class ParticipantViewController: UIViewController, SessionManagerDelegate {
  var session = ParticipantSessionManager()
  
  @IBOutlet weak var connectedView: UIView!
  
  let animationDuration = NSTimeInterval(0.5)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    session.delegate = self
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
    
  func showConnected(){
    MBProgressHUD.hideHUDForView(self.view, animated: true)
    connectedView.hidden = false
  }
  
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {
    if thisSessionDidConnect {
      showConnected()
    }
  }
  
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {
    showConnected()
  }
  
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {
    print(data)
  }
}
