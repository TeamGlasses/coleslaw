//
//  ViewController.swift
//  coleslaw
//
//  Created by Jack Kearney on 3/5/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, CardViewDelegate {

  @IBOutlet var roundLabel: UILabel!
  @IBOutlet var teamAScoreLabel: UILabel!
  @IBOutlet var teamBScoreLabel: UILabel!
  @IBOutlet var timerLabel: UILabel!
  
  @IBOutlet weak var card: CardView!
  
  var game: GameState!
  var currentScoreLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    card.delegate = self
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
    
    print("card view was advanced")
  }
  
  func cardViewDismissed(cardView: CardView) {
    print("card view was dismissed")
  }
  
  func cardViewFinishedAnimating(cardView: CardView) {
    print("card view finished animating")
  }
}

