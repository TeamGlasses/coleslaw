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

  func createGame() -> Game {
    let redTeam = Team(id: 0, name: "Team Red")
    let blueTeam = Team(id: 1, name: "Team Blue")
    let allTeams = [redTeam, blueTeam]
    var allPlayers = [Player]()

    for (index, _) in session.peers.enumerate() {
      if index % 2 == 0 {
        allPlayers.append(Player(id: index, team: allTeams[0]))
      } else {
        allPlayers.append(Player(id: index, team: allTeams[1]))
      }
    }

    game = Game(allCards: allCards, allTeams: allTeams, allPlayers: allPlayers)

//    session.broadcast("game", value: game)

//    for (index, peer) in session.peers.enumerate() {
//      session.sendMessage("assignPlayer", value: allPlayers[index], toPeer: peer)
//    }

    let test = Test(val: "this is a test string")
    session.broadcast("test", value: test)

    return game
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationViewController = segue.destinationViewController as! RoundStartViewController

    destinationViewController.game = createGame()
  }
  
  @IBAction func onStartGame(sender: UIButton) {
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
