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
    let winnerColor = game.winner.color
    let loserColor = game.loser.color
    
    view.backgroundColor = winnerColor
    
    winnerAnnouncementLabel.textColor = UIColor.whiteColor()
    winnerAnnouncementLabel.font = UIFont(name: "SFUIText-Semibold", size: 50)
    scoresView.layer.cornerRadius = 16
    scoresView.layer.shadowOpacity = 0.2
    scoresView.layer.shadowOffset = CGSizeMake(0, 0)
    scoresView.layer.shadowRadius = 16
    scoresView.layer.shadowColor = UIColor.blackColor().CGColor
    scoresView.layer.masksToBounds = false
    scoresView.clipsToBounds = false

    winnerAnnouncementLabel.text = "\(game.winner.name) Wins!"
    let scores = game.scores
    
    winnerScoreLabel.text = "\(scores[game.winner.id])"
    winnerScoreLabel.textColor = winnerColor
    winnerScoreLabel.font = UIFont(name: "SFUIDisplay-Bold", size: 50)

    loserScoreLabel.text = "\(scores[game.loser.id])"
    loserScoreLabel.textColor = loserColor
    loserScoreLabel.font = UIFont(name: "SFUIDisplay-Light", size: 50)

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

    cell.round = localGame.game.rounds[indexPath.row]
    cell.gameWinner = localGame.game.winner
    cell.gameLoser = localGame.game.loser

    return cell
  }
}

extension ResultsViewController: UITableViewDelegate {

}
