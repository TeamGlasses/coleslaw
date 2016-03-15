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
  @IBOutlet weak var startButton: UIButton!

  var game: Game!
  var allCards: [Card]!
  
  var session = OwnerSessionManager()
  
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

  func createGame() {
    var teamColors = [UIColor(red: 201.0/255.0, green: 56.0/255.0, blue: 87.0/255.0, alpha: 1), UIColor(red: 56.0/255.0, green: 126.0/255.0, blue: 201.0/255.0, alpha: 1)]
    
    let redTeam = Team(id: 0, name: "Team Red", color: teamColors[0])

    let blueTeam = Team(id: 1, name: "Team Blue", color: teamColors[1])
    
    let allTeams = [redTeam, blueTeam]

    var allPlayers = [Player]()

    for (index, _) in session.peers.enumerate() {
      if index % 2 == 0 {
        allPlayers.append(Player(id: index, team: allTeams[0]))
      } else {
        allPlayers.append(Player(id: index, team: allTeams[1]))
      }
    }
    
    // Add owner to game
    let ownerIndex = session.peers.count
    let ownerPlayer = Player(id: ownerIndex, team: allTeams[ownerIndex % 2])
    allPlayers.append(ownerPlayer)
    
    game = Game(allCards: allCards, allTeams: allTeams, allPlayers: allPlayers)
    
    LocalGameManager.sharedInstance.game = game
    LocalGameManager.sharedInstance.localPlayer = ownerPlayer

    for (index, peer) in session.peers.enumerate() {
      var value = [String: AnyObject]()
      value["player"] = allPlayers[index]
      value["game"] = game

      session.sendMessage("assignPlayerAndGame", value: value, toPeer: peer)
    }
  }
  
  @IBAction func onStartGame(sender: UIButton) {
    createGame()
    performSegueWithIdentifier("ownerStartGame", sender: self)
  }
  
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {
    dispatch_async(dispatch_get_main_queue()){
      self.connectionsLabel.titleLabel!.text = "\(self.session.peers.count)"
    }
  }
  
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {}
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {}
}
