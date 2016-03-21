//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let TURN_LENGTH = 60

class CardsViewController: UIViewController {

  var activeCardView: CardView!

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  @IBOutlet weak var cardsRemainingLabel: UILabel!

  var timer: NSTimer!
  
  var statusView: StatusView!
  var fakeCards: [UIView]!
  
  var localGame: LocalGameManager {
    return LocalGameManager.sharedInstance
  }

  var timeRemaining = TURN_LENGTH
  
  // ideally all the UI stuff shoudl be in a separate view class
  override func viewWillAppear(animated: Bool) {
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

    cardsRemainingLabel.hidden = true
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
    
    timerLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 76)
    cardsRemainingLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 16)
    
    // view background
    view.backgroundColor = LocalGameManager.sharedInstance.localColor
    
    startButton.layer.cornerRadius = 16
    startButton.clipsToBounds = true
    startButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    startButton.titleLabel!.textAlignment = NSTextAlignment.Center
    startButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 40)
    
    statusView = StatusView()
    statusView.translatesAutoresizingMaskIntoConstraints = false
    statusView.renderInView(view)

    statusView.game = localGame.game
    prepareNextTurn()
    initializeTimer()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning() 
    // Dispose of any resources that can be recreated.
  }
  
  func updateOnTurnStart(){
    initializeTimer()
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)

    if localGame.isCurrentPlayer {
      startButton.hidden = true
      startButton.setTitle("", forState: .Normal)

      let cardsRemaining = localGame.game.currentRound.toGuessCards.count
      if cardsRemaining <= 3 {
        cardsRemainingLabel.hidden = false
        cardsRemainingLabel.text = "Cards Remaining: \(cardsRemaining)"
      }

      addCardView(localGame.game.currentRound.randomCard)
      
      if cardsRemaining > 2 {
        fakeCards = [addFakeCardView(Card(title: ""), multiplier: 0.98, bottomOffset: -7),
          addFakeCardView(Card(title: ""), multiplier: 0.96, bottomOffset: -14)]
      } else if cardsRemaining == 2 {
        fakeCards = [addFakeCardView(Card(title: ""), multiplier: 0.98, bottomOffset: -7)]
      }
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
    timer.invalidate()
    performSegueWithIdentifier("moveToResults", sender: self)
  }
  
  func updateTimer(timer: NSTimer) {
    timeRemaining -= 1
    updateTimerLabel()
    
    if (localGame.isCurrentPlayer && timeRemaining <= 0) {
      localGame.game.turnEnd()
    }
  }
  
  func initializeTimer(){
    timeRemaining = TURN_LENGTH
    updateTimerLabel()
  }
  
  func updateTimerLabel(){
    timerLabel.text = String(format: "0:%02d", timeRemaining)
  }

  func showNextCard(advanced: Bool){
    activeCardView.removeFromSuperview()

    let cardsRemaining = localGame.game.currentRound.toGuessCards.count
    if cardsRemaining <= 3 {
      cardsRemainingLabel.hidden = false
      cardsRemainingLabel.text = "Cards Remaining: \(cardsRemaining)"
    }

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
}

extension CardsViewController: GameDelegate {
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
}

extension CardsViewController: SessionManagerDelegate {
  func sessionManager(sessionManager: SessionManager, didReceiveData data: NSDictionary) {
    let game = data["value"] as! Game
    localGame.game = game
    localGame.game.delegate = self

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
    
    game.completeCurrentCard()

    if game.currentRound.isOver {
      game.turnEnd()
    } else {
      showNextCard(true)
    }
  }

  func cardViewDismissed(cardView: CardView) {
    let currentRound = localGame.game.currentRound
    if currentRound.toGuessCards.count > 1 && !currentRound.currentTurn.isOver {
      showNextCard(false)
    } else {
      localGame.game.turnEnd()
    }
  }

  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
}

