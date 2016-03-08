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

  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var teamAScoreLabel: UILabel!
  @IBOutlet weak var teamBScoreLabel: UILabel!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!

  var game: Game!

  var scoreLabels: [UILabel]!
  var timer: NSTimer!

  override func viewDidLoad() {
    super.viewDidLoad()

    scoreLabels = [teamAScoreLabel, teamBScoreLabel]
    
    gameStart()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning() 
    // Dispose of any resources that can be recreated.
  }

  func gameStart() {
    let redTeam = Team(id: 0, name: "Team Red")
    let blueTeam = Team(id: 1, name: "Team Blue")
    let playerZero = Player(team: redTeam)
    let playerOne = Player(team: blueTeam)
    let allPlayers = [playerZero, playerOne]
    let allCards = [
      Card(title: "Donald Trump"),
      Card(title: "Pizza"),
      Card(title: "San Francisco")
    ]
    game = Game(allCards: allCards, allPlayers: allPlayers)

    timerLabel.text = "..."
    roundLabel.text = "Ready for Round #\(game.rounds.count+1)"
  }

  func roundStart() {
    let newRound = Round(toGuessCards: game.allCards, roundTypeRawValue: game.currentRoundIndex + 1)
    game.rounds.append(newRound)

    timerLabel.text = "..."
    roundLabel.text = "Ready for Round #\(game.currentRoundIndex + 1), Turn #\(newRound.currentTurnIndex + 2) with Player #\(game.currentPlayerIndex + 1)"
  }

  func turnStart() {
    let newTurn = Turn(activePlayer: game.allPlayers[game.currentPlayerIndex])
    game.rounds[game.currentRoundIndex].turns.append(newTurn)

    roundLabel.text = "Round #\(game.currentRoundIndex + 1) - \(newTurn.activePlayer.team.name) - Player #\(game.currentPlayerIndex + 1)"
    startButton.hidden = true

    timerLabel.text = "1:00"
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)

    addCardView(game.currentRound.toGuessCards.last!)
  }

  func turnEnd() {
    game.currentPlayerIndex += 1
    roundLabel.text = "Ready for Round #\(game.currentRoundIndex + 1), Turn #\(game.currentRound.currentTurnIndex + 1) with Player #\(game.currentPlayerIndex + 1)"

    activeCardView.removeFromSuperview()
    startButton.hidden = false

    timer.invalidate()

    if game.currentRound.isOver {
      roundEnd()
    }
  }

  func roundEnd() {
    game.currentPlayerIndex += 1

    if activeCardView != nil {
      activeCardView.removeFromSuperview()
    }
    startButton.hidden = false

    timer.invalidate()

    // TODO: could add more end of round info/instructions

    roundStart()
  }

  func gameEnd() {
    // TODO: move to results VC
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

  func showNextCard(){
    activeCardView.removeFromSuperview()

    addCardView(game.currentRound.toGuessCards.last!)
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
}

extension CardsViewController: CardViewDelegate {
  func cardViewAdvanced(cardView: CardView) {
    print("here")
    let currentRound = game.rounds[game.currentRoundIndex]
    let currentTurn = currentRound.turns[currentRound.currentTurnIndex]
    print(currentRound.toGuessCards.count)
    let card = currentRound.toGuessCards.removeLast()
    print(card)
    print(currentRound.toGuessCards.count)
    currentTurn.completedCards.append(card)

    scoreLabels[currentTurn.currentTeamIndex].text = "\(game.scores[currentTurn.currentTeamIndex])"

    if currentRound.isOver {
      roundEnd()
      return
    }

    showNextCard()
  }

  func cardViewDismissed(cardView: CardView) {

  }

  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
}

