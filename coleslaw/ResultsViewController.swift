//
//  ResultsViewController.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

  @IBOutlet weak var winnerAnnouncementLabel: UILabel!
  @IBOutlet var winnerScoreLabel: UILabel!
  @IBOutlet var loserScoreLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet var scoresView: UIView!
  var localGame: LocalGameManager {
    return LocalGameManager.sharedInstance
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self
    
    let game = localGame.game
    let scores = game.scores
    
    var winner = game.winner
    var loser = game.loser
    let winnerFont = "SFUIDisplay-Bold"
    var loserFont = "SFUIDisplay-Light"
    var winnerColor = winner.color
    var winnerText = game.winner.name
    
    if game.isTied {
      winner = game.allTeams[0]
      loser = game.allTeams[1]
      winnerText = "Everyone"
      loserFont = "SFUIDisplay-Bold"
      winnerColor = UIColor(red: 167.0/255.0, green: 19.0/255.0, blue: 129.0/255.0, alpha: 1)
    }

    view.backgroundColor = winnerColor
    
    winnerScoreLabel.text = "\(scores[winner.id])"
    winnerScoreLabel.textColor = winner.color

    loserScoreLabel.text = "\(scores[loser.id])"
    loserScoreLabel.textColor = loser.color
    
    winnerAnnouncementLabel.text = "\(winnerText) Wins!"
    
    winnerAnnouncementLabel.textColor = UIColor.whiteColor()
    winnerAnnouncementLabel.font = UIFont(name: "SFUIText-Semibold", size: 50)
    scoresView.layer.cornerRadius = 16

    winnerScoreLabel.font = UIFont(name: winnerFont, size: 50)
    loserScoreLabel.font = UIFont(name: loserFont, size: 50)

    tableView.reloadData()
  }

  @IBAction func onDismiss(sender: AnyObject) {
    let initialViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
    initialViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension ResultsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return localGame.game.rounds.count
  }

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RoundResultCell", forIndexPath: indexPath) as! RoundResultCell

    let game = localGame.game
    var winner = game.winner
    var loser = game.loser
  
    if game.isTied {
      winner = game.allTeams[0]
      loser = game.allTeams[1]
    }
  
    cell.round = localGame.game.rounds[indexPath.row]
    cell.gameWinner = winner
    cell.gameLoser = loser
    cell.isTied = game.isTied

    return cell
  }
}

extension ResultsViewController: UITableViewDelegate {

}
