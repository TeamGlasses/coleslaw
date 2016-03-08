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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ResultsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RoundResultCell", forIndexPath: indexPath) as! RoundResultCell

        // TODO: pass Round object and fill data

        return cell
    }
}

extension ResultsViewController: UITableViewDelegate {

}
