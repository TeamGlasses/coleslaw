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
  @IBOutlet weak var redScoreLabel: UILabel!
  @IBOutlet weak var blueScoreLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!

  var game: Game!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    winnerAnnouncementLabel.text = "\(game.winner.name) Won!"
    let scores = game.scores
    redScoreLabel.text = "\(scores[0])"
    blueScoreLabel.text = "\(scores[1])"

    tableView.reloadData()
  }

  @IBAction func didTapDone(sender: UIBarButtonItem) {
    let initialViewController = storyboard?.instantiateInitialViewController()
    presentViewController(initialViewController!, animated: true, completion: nil)
  }
}

extension ResultsViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return game.rounds.count
  }

func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("RoundResultCell", forIndexPath: indexPath) as! RoundResultCell

    cell.round = game.rounds[indexPath.row]

    return cell
  }
}

extension ResultsViewController: UITableViewDelegate {

}
