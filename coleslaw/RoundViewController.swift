//
//  RoundViewController.swift
//  coleslaw
//
//  Created by Max Pappas on 3/13/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import UIKit

class RoundViewController: UIViewController {

  var statusView: StatusView!

  @IBOutlet var infoView: UIView!
  @IBOutlet var startButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = LocalGameManager.sharedInstance.localColor

    
    statusView = StatusView()
    statusView.translatesAutoresizingMaskIntoConstraints = false
    statusView.renderInView(view)
    
    // view background
    view.backgroundColor = LocalGameManager.sharedInstance.localColor
    
    //button
    startButton.layer.cornerRadius = 16
    startButton.clipsToBounds = true
    startButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    startButton.titleLabel!.textAlignment = NSTextAlignment.Center
    startButton.titleLabel!.font = UIFont(name: "SFUIDisplay-Medium", size: 40)

    let isOwner = LocalGameManager.sharedInstance.session.isOwner
    startButton.hidden = !isOwner
    startButton.enabled = isOwner
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */


}
