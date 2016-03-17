//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

  var activeCardView: CardView!

  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  
  var allCards: [Card]!
  var game: Game!

  var timer: NSTimer!
  var teamColors = [UIColor(red: 201.0/255.0, green: 56.0/255.0, blue: 87.0/255.0, alpha: 1), UIColor(red: 56.0/255.0, green: 126.0/255.0, blue: 201.0/255.0, alpha: 1)]
  
  var statusView: StatusView!
  var fakeCards: [UIView]!
  
  // ideally all the UI stuff shoudl be in a separate view class
  override func viewWillAppear(animated: Bool) {
    timerLabel.font = UIFont(name: "SFUIDisplay-Semibold", size: 76)
    
    // view background
    view.backgroundColor = teamColors[0]
    
    //button
    startButton.layer.cornerRadius = 16
    startButton.clipsToBounds = true
    startButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    startButton.titleLabel!.textAlignment = NSTextAlignment.Center
    startButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 40)
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
    let redTeam = Team(id: 0, name: "Team Red")
    let blueTeam = Team(id: 1, name: "Team Blue")
    let allTeams = [redTeam, blueTeam]
    let playerZero = Player(id: 0, team: redTeam)
    let playerOne = Player(id: 1, team: blueTeam)
    let allPlayers = [playerZero, playerOne]
    game = Game(allCards: allCards, allTeams: allTeams, allPlayers: allPlayers)
    prepareNextTurn()

    //timerLabel.text = "..."
    statusView.roundLabel.text = "Round \(game.rounds.count+1)"
    statusView.game = game
  }

  func roundStart() {
    let newRound = Round(toGuessCards: game.allCards, roundTypeRawValue: game.currentRoundIndex + 1, game: game)
    game.rounds.append(newRound)

    //timerLabel.text = "..."
    statusView.roundLabel.text = "Round \(game.currentRoundIndex + 1), Turn #\(newRound.currentTurnIndex + 2) with Player \(game.currentPlayerIndex + 1)"
  }
  
  func prepareNextTurn() {
    let currentPlayer = game.allPlayers[game.currentPlayerIndex]
    let nextTeam = currentPlayer.team
    view.backgroundColor = teamColors[nextTeam.id]
    
    startButton.setTitle("Start\n\(nextTeam.name)", forState: .Normal)
  }

  func turnStart() {
    let newTurn = Turn(activePlayer: game.allPlayers[game.currentPlayerIndex])
    game.rounds[game.currentRoundIndex].turns.append(newTurn)

    // move UI logic to separate class using delegates?
    statusView.roundLabel.text = "Round \(game.currentRoundIndex + 1) - \(newTurn.activePlayer.team.name) - Player \(game.currentPlayerIndex + 1)"
    startButton.hidden = true
    startButton.setTitle("", forState: .Normal)

    timerLabel.text = "1:00"
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)

    addCardView(game.currentRound.randomCard)
    
    fakeCards = [addFakeCardView(Card(title: ""), multiplier: 0.98, bottomOffset: -7),
    addFakeCardView(Card(title: ""), multiplier: 0.96, bottomOffset: -14)]
  }

  func turnEnd() {
    game.currentPlayerIndex += 1
    statusView.roundLabel.text = "Round \(game.currentRoundIndex + 1), Turn #\(game.currentRound.currentTurnIndex + 1) with Player \(game.currentPlayerIndex + 1)"
    
    prepareNextTurn()
    statusView.game = game

    activeCardView.removeFromSuperview()

    timer.invalidate()
    startButton.hidden = false
    
    for fakeCard in fakeCards {
      fakeCard.removeFromSuperview()
    }
    
    fakeCards = []

    if game.currentRound.isOver {
      roundEnd()
    }
  }

  func roundEnd() {
    if activeCardView != nil {
      activeCardView.removeFromSuperview()
    }
    startButton.hidden = false

    timer.invalidate()

    // TODO: could add more end of round info/instructions

    if game.isOver {
      gameEnd()
    } else {
      roundStart()
    }
  }

  func gameEnd() {
    performSegueWithIdentifier("moveToResults", sender: self)
  }

  func updateTimer(timer: NSTimer) {
    let currentRound = game.rounds[game.currentRoundIndex]
    let currentTurn = currentRound.turns[currentRound.currentTurnIndex]
    currentTurn.updateTimer()

    timerLabel.text = String(format: "0:%02d", currentTurn.timeRemaining)

    if (currentTurn.timeRemaining == 0) {
      turnEnd()
    }
  }

  func showNextCard(advanced: Bool){
    activeCardView.removeFromSuperview()

    print(game.currentRound.toGuessCards.count)
    print(fakeCards.count)
    if game.currentRound.toGuessCards.count < 3 && fakeCards.count > 0 && advanced {
      fakeCards.popLast()!.removeFromSuperview()
    }
    
    addCardView(game.currentRound.randomCard)
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
    if game.rounds.count == 0 || game.currentRound.isOver {
      roundStart()
    } else {
      turnStart()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationNavigationViewController = segue.destinationViewController as! UINavigationController
    let destinationResultsViewController = destinationNavigationViewController.viewControllers.first as! ResultsViewController
    destinationResultsViewController.game = game
  }
}

extension CardsViewController: CardViewDelegate {
  func cardViewAdvanced(cardView: CardView) {
    let currentRound = game.rounds[game.currentRoundIndex]
    let currentTurn = currentRound.turns[currentRound.currentTurnIndex]
    let card = currentRound.toGuessCards.removeAtIndex(currentRound.lastCardIndex)
    currentTurn.completedCards.append(card)

    statusView.scoreLabels[currentTurn.currentTeamIndex].text = "\(game.scores[currentTurn.currentTeamIndex])"

    if currentRound.isOver {
      turnEnd()
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

