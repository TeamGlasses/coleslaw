//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CardsViewController: UIViewController, SessionManagerDelegate {

  var activeCardView: CardView!

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!

  var timer: NSTimer!
  
  var statusView: StatusView!
  
  var localGame: LocalGameManager {
    return LocalGameManager.sharedInstance
  }
  
  // ideally all the UI stuff shoudl be in a separate view class
  override func viewWillAppear(animated: Bool) {
    timerLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 76)
    
    // view background
    view.backgroundColor = LocalGameManager.sharedInstance.localColor
    
    startButton.layer.cornerRadius = 16
    startButton.clipsToBounds = true
    startButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    startButton.titleLabel!.textAlignment = NSTextAlignment.Center
    startButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 40)
    
    localGame.session.delegate = self
  }
  
  func prepareNextTurn(){
    startButton.hidden = false
    
    if localGame.isCurrentPlayer {
      startButton.titleLabel!.text = "Start Turn"
    } else if localGame.isOnCurrentTeam {
      startButton.enabled = false
      startButton.titleLabel!.text = "Guess!"
    } else {
      startButton.enabled = false
      startButton.titleLabel!.text = "Wait!"
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    statusView = StatusView()
    statusView.translatesAutoresizingMaskIntoConstraints = false
    statusView.renderInView(view)

    gameStart()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning() 
    // Dispose of any resources that can be recreated.
  }

  func gameStart() {
    prepareNextTurn()
    statusView.game = localGame.game
  }
  
  func turnStart() {
    let game = localGame.game
    let newTurn = Turn(activePlayer: game.allPlayers[game.currentPlayerIndex])
    game.rounds[game.currentRoundIndex].turns.append(newTurn)

    // move UI logic to separate class using delegates?
    startButton.hidden = true
    startButton.setTitle("", forState: .Normal)

    timerLabel.text = "1:00"
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)

    addCardView(game.currentRound.randomCard)
  }

  func turnEnd() {
    let game = localGame.game
    game.currentPlayerIndex += 1
    statusView.game = game
    activeCardView.removeFromSuperview()
    timer.invalidate()

    prepareNextTurn()
    localGame.session.broadcast("turnEnd", value: game)
  }

  func roundEnd() {
    let game = localGame.game

    if activeCardView != nil {
      activeCardView.removeFromSuperview()
    }

    timer.invalidate()

    if game.isOver {
      gameEnd()
    } else {
      localGame.session.broadcast("roundEnd", value: game)
      dismissViewControllerAnimated(true, completion: nil)
    }
  }

  func gameEnd() {
    performSegueWithIdentifier("moveToResults", sender: self)
  }

  func updateTimer(timer: NSTimer) {
    let game = localGame.game
    let currentRound = game.rounds[game.currentRoundIndex]
    let currentTurn = currentRound.turns[currentRound.currentTurnIndex]
    currentTurn.updateTimer()

    timerLabel.text = String(format: "0:%02d", currentTurn.timeRemaining)

    if (currentTurn.timeRemaining == 0) {
      turnEnd()
    }
  }

  func showNextCard(){
    activeCardView.removeFromSuperview()
    addCardView(localGame.game.currentRound.randomCard)
  }

  func addCardView(card: Card){
    let cardView = CardView()
    cardView.translatesAutoresizingMaskIntoConstraints = false
    cardView.card = card
    cardView.delegate = self
    cardView.renderInView(view)

    activeCardView = cardView
  }
  
  @IBAction func onStartTap(sender: AnyObject) {
    turnStart()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationNavigationViewController = segue.destinationViewController as! UINavigationController
    let destinationResultsViewController = destinationNavigationViewController.viewControllers.first as! ResultsViewController
    destinationResultsViewController.game = localGame.game
  }

  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {
    let game = data["value"] as! Game
    localGame.game = game

    let message = data["message"] as! String
    
    if message == "turnEnd" {
      prepareNextTurn()
    } else if message == "roundEnd" {
      dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func sessionManager(sessionManager: SessionManager, thisSessionDidConnect: Bool) {}
  func sessionManager(sessionManager: SessionManager, peerDidConnect peerID: MCPeerID) {}
}

extension CardsViewController: CardViewDelegate {
  func cardViewAdvanced(cardView: CardView) {
    let game = localGame.game
    let currentRound = game.rounds[game.currentRoundIndex]
    let currentTurn = currentRound.turns[currentRound.currentTurnIndex]
    let card = currentRound.toGuessCards.removeAtIndex(currentRound.lastCardIndex)
    currentTurn.completedCards.append(card)

    statusView.scoreLabels[currentTurn.currentTeamIndex].text = "\(game.scores[currentTurn.currentTeamIndex])"

    if currentRound.isOver {
      turnEnd()
    } else {
      showNextCard()
    }
  }

  func cardViewDismissed(cardView: CardView) {
    showNextCard()
  }

  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
}

