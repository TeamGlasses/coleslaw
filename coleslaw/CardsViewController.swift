//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, CardViewDelegate {

  var cards: [Card]!
  var activeCardView: CardView!

  @IBOutlet var roundLabel: UILabel!
  @IBOutlet var teamAScoreLabel: UILabel!
  @IBOutlet var teamBScoreLabel: UILabel!
  @IBOutlet var timerLabel: UILabel!

  var game: GameState!
  var currentScoreLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    cards = [
      Card(title: "Barack Obama"),
      Card(title: "Mt. Everest"),
      Card(title: "Donald Trump"),
      Card(title: "Pizza"),
      Card(title: "San Francisco")
    ]

    currentScoreLabel = teamAScoreLabel

    game = GameState()

    onGameStart()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func onGameStart() {
    onTurnStart()
  }

  func onTurnStart() {
    game.currentTime = game.gameTime
    let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
    
    addCardView(cards.first!)
  }

  func updateTimer(timer: NSTimer) {
    game.currentTime = game.currentTime - 1

    timerLabel.text = String(format: "0:%02d", game.currentTime)

    if (game.currentTime == 0) {
      timer.invalidate()
      onTurnEnd()

      onTurnStart()
    }
  }

  // this will get called if timer = 0
  // or if deck reaches 0
  func onTurnEnd() {
    // if timer 0, update turn only
    if (game.currentTeam == 0) {
      game.currentTeam = 1
      currentScoreLabel = teamBScoreLabel
    } else {
      game.currentTeam = 0
      currentScoreLabel = teamAScoreLabel
    }

    // if cards empty, update Round #
    // game.currentRound = game.currentRound + 1

    roundLabel.text = "Round \(game.currentRound) - Team \(game.teams[game.currentTeam])"
  }

  func cardViewAdvanced(cardView: CardView) {
    game.scores[game.currentTeam] = game.scores[game.currentTeam] + 1

    currentScoreLabel.text = String(game.scores[game.currentTeam])

    showNextCard()
  }

  func cardViewDismissed(cardView: CardView) {
    showNextCard()
  }

  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
  
  func showNextCard(){
    let nextCardIndex = cards.indexOf(activeCardView.card)! + 1
    
    activeCardView.removeFromSuperview()

    if cards.count <= nextCardIndex {
      onTurnEnd()
    } else {
      let nextCard = cards[nextCardIndex]
      addCardView(nextCard)
    }
  }

  func addCardView(card: Card){
    let cardView = CardView()
    cardView.translatesAutoresizingMaskIntoConstraints = false
    cardView.card = card
    cardView.delegate = self

    view.addSubview(cardView)
    
    activeCardView = cardView

    cardView.constraints
    let views = ["cardView": cardView]

    var constraints = [NSLayoutConstraint]()

    let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[cardView(300)]-|", options: [], metrics: nil, views: views)
    constraints += verticalConstraints

    let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-[cardView]-|", options: [], metrics: nil, views: views)
    constraints += horizontalConstraints

    NSLayoutConstraint.activateConstraints(constraints)
  }
}

