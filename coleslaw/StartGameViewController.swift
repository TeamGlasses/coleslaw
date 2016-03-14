//
//  StartGameViewController.swift
//  coleslaw
//
//  Created by Michael Bock on 3/6/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import MBProgressHUD
import UIKit

class StartGameViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var startButton: UIButton!

  var gameNames = [String]()

  var allCards = [Card]()

  override func viewDidLoad() {
    super.viewDidLoad()

    // This hides extra empty cells.
    tableView.tableFooterView = UIView()

    tableView.dataSource = self
    tableView.delegate = self

    FirebaseClient.sharedInstance.getAllGameNames { (gameNames: [String]!) -> Void in
      self.gameNames = gameNames
      self.tableView.reloadData()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let destinationViewController = segue.destinationViewController as! CardsViewController
    destinationViewController.allCards = allCards
  }

  @IBAction func didTapStart(sender: UIButton) {
    performSegueWithIdentifier("startGame", sender: self)
  }
}

extension StartGameViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gameNames.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("GameNameCell", forIndexPath: indexPath)
    cell.textLabel!.text = gameNames[indexPath.row]
    return cell
  }
}

extension StartGameViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.accessoryType = .Checkmark

    // Get cards for this game.
    startButton.enabled = false
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    FirebaseClient.sharedInstance.getCards(cell?.textLabel?.text ?? "demo") { (cards: [Card]!) -> Void in
      self.allCards = cards
      self.startButton.enabled = true
      MBProgressHUD.hideHUDForView(self.view, animated: true)
    }

    // Turn off all other checkmarks.
    for index in 0...gameNames.count-1 {
      if index != indexPath.row {
        let otherCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
        otherCell?.accessoryType = .None
      }
    }
  }
}