//
//  Team.swift
//  coleslaw
//
//  Created by Michael Bock on 3/7/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Foundation

enum TeamType: String {
    case Red = "Team Red", Blue = "Team Blue"
}

class Team: NSObject {
    var teamType: TeamType?
    var players: [Player]?
}
