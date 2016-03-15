//
//  SessionManager.swift
//  MCTest
//
//  Created by Jack Kearney on 3/12/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol SessionManagerDelegate {
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary)
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID)
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool)
}

class SessionManager: NSObject, MCSessionDelegate {
  var peers: [MCPeerID] {
    get {
      return session.connectedPeers
    }
  }
  
  var delegate: SessionManagerDelegate!
  
  var isOwner: Bool {
    return false
  }
  
  private let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
  
  private lazy var session: MCSession = {
    let session = MCSession(peer: self.peerID)
    session.delegate = self
    return session
  }()
  
  let kColeslawServiceType = "team-coleslaw"
  
  override init () {
    super.init()
    start()
  }
  
  func start(){}
  
  func broadcast(message: String, value: AnyObject){
    sendMessage(message, value: value, toPeers: self.peers)
  }

  func sendMessage(message: String, value: AnyObject, toPeer peer: MCPeerID) {
    sendMessage(message, value: value, toPeers: [peer])
  }
  
  private func sendMessage(message: String, value: AnyObject, toPeers: [MCPeerID]){
    var payload = [String: AnyObject]()
    payload["message"] = message
    payload["value"] = value
    
    do {
      let encodedPayload = NSKeyedArchiver.archivedDataWithRootObject(payload)
      try self.session.sendData(encodedPayload, toPeers: toPeers, withMode: .Reliable)
    } catch let error as NSError {
      NSLog("Error sending data")
      NSLog("\(error)")
    }
  }
  
  // SessionDelegate Interface
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    do {
      let decodedData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [String: AnyObject]
      dispatch_async(dispatch_get_main_queue()){
        self.delegate.sessionManager(self, didReceiveData: decodedData)
      }
    } catch let error as NSError {
      dispatch_async(dispatch_get_main_queue()){
        NSLog("Error receiving data")
        NSLog("\(error)")
      }
    }
  }
  
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    if state == .Connected {
      dispatch_async(dispatch_get_main_queue()){
        if peerID == session.myPeerID {
          self.delegate.sessionManager(self, thisSessionDidConnect: true)
        } else {
          self.delegate.sessionManager(self, peerDidConnect: peerID)
        }
      }
    }
  }
  
  // Required for MCSessionDelegate, but unnecessary for current implementation
  func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
  func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {}
}

class OwnerSessionManager: SessionManager, MCNearbyServiceBrowserDelegate {
  override var isOwner: Bool {
    return true
  }
  
  private lazy var browser: MCNearbyServiceBrowser = {
    let browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.kColeslawServiceType)
    browser.delegate = self
    return browser
  }()
  
  override func start(){
    browser.startBrowsingForPeers()
  }
  
  // BrowserDelegate Interface
  
  // Automatically invite every peer found
  func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: NSTimeInterval(30))
  }
  
  func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    NSLog("Lost peer")
    NSLog("\(peerID)")
  }
}

class ParticipantSessionManager: SessionManager, MCNearbyServiceAdvertiserDelegate {
  private var ownerPeerID: MCPeerID!
  
  private lazy var advertiser: MCNearbyServiceAdvertiser = {
    let advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.kColeslawServiceType)
    advertiser.delegate = self
    return advertiser
  }()
  
  override func start(){
    advertiser.startAdvertisingPeer()
  }
  
  // AdvertiserDelegate Interface
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
    self.ownerPeerID = peerID
    invitationHandler(true, session)
  }
}
