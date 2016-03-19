//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CardsViewController: UIViewController, SessionManagerDelegate, GameDelegate {

  var activeCardView: CardView!

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!

  var timer: NSTimer!
  
  var statusView: StatusView!
  var fakeCards: [UIView]!
  
  var localGame: LocalGameManager {
    return LocalGameManager.sharedInstance
  }
  
  var timeRemaining = 60
  
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
    localGame.game.delegate = self
  }
  
  func prepareNextTurn(){
    startButton.hidden = false
    
    if fakeCards != nil {
      for fakeCard in fakeCards {
        fakeCard.removeFromSuperview()
      }
    }
    
    fakeCards = []
    
    if localGame.isCurrentPlayer {
      startButton.enabled = true
      startButton.setTitle("Start Turn", forState: .Normal)
    } else if localGame.isOnCurrentTeam {
      startButton.enabled = false
      startButton.setTitle("Guess!", forState: .Normal)
    } else {
      startButton.enabled = false
      startButton.setTitle("Wait!", forState: .Normal)
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
    statusView.game = localGame.game
    prepareNextTurn()
  }
  
  func updateOnTurnStart(){
    timerLabel.text = "1:00"
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)

    if localGame.isCurrentPlayer {
      startButton.hidden = true
      startButton.setTitle("", forState: .Normal)

      addCardView(localGame.game.currentRound.randomCard)
      fakeCards = [addFakeCardView(Card(title: ""), multiplier: 0.98, bottomOffset: -7),
      addFakeCardView(Card(title: ""), multiplier: 0.96, bottomOffset: -14)]
    }
  }
  
  func updateOnTurnEnd(){
    // TODO: Remove
    statusView.game = LocalGameManager.sharedInstance.game
    if activeCardView != nil {
      activeCardView.removeFromSuperview()
    }
    timer.invalidate()
    timerLabel.text = "0:00"

    prepareNextTurn()
  }
  
  func updateOnRoundEnd(){
    if activeCardView != nil {
      activeCardView.removeFromSuperview()
    }

    timer.invalidate()
    dismissViewControllerAnimated(true, completion: nil)
  }

  func updateOnGameEnd(){
    performSegueWithIdentifier("moveToResults", sender: self)
  }
  
  func gameDidEnd(game: Game) {
    updateOnGameEnd()
  }

  func gameRoundDidEnd(game: Game) {
    updateOnRoundEnd()
  }
  
  func gameTurnDidEnd(game: Game) {
    updateOnTurnEnd()
  }
  
  func gameTurnDidStart(game: Game){
    updateOnTurnStart()
  }
  
  func updateTimer(timer: NSTimer) {
    timeRemaining -= 1
    timerLabel.text = String(format: "0:%02d", timeRemaining)
    
    if (localGame.isCurrentPlayer && timeRemaining == 0) {
      localGame.game.turnEnd()
    }
  }

  func showNextCard(advanced: Bool){
    activeCardView.removeFromSuperview()
    
    if localGame.game.currentRound.toGuessCards.count < 3 && fakeCards.count > 0 && advanced {
      fakeCards.popLast()!.removeFromSuperview()
    }

    addCardView(localGame.game.currentRound.randomCard)
  }
  
  func addFakeCardView(card: Card, multiplier: CGFloat, bottomOffset: CGFloat) -> UIView {
    let cardView = CardView()
    cardView.card = card
    cardView.translatesAutoresizingMaskIntoConstraints = false
    cardView.renderFakeCard(view, multiplier: multiplier, bottomOffset: bottomOffset)
    view.sendSubviewToBack(cardView)
    
    return cardView as UIView
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
    localGame.game.turnStart()
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
    
    if message == "turnStart" {
      updateOnTurnStart()
    } else if message == "turnEnd" {
      updateOnTurnEnd()
    } else if message == "roundEnd" {
      updateOnRoundEnd()
    } else if message == "gameEnd" {
      updateOnGameEnd()
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
      game.turnEnd()
    } else {
      showNextCard(true)
    }
  }

  func cardViewDismissed(cardView: CardView) {
    showNextCard(false)
  }

  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
}

