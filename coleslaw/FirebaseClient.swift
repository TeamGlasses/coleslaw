//
//  FirebaseClient.swift
//  coleslaw
//
//  Created by Michael Bock on 3/12/16.
//  Copyright © 2016 Jack Kearney. All rights reserved.
//

import Firebase
import Foundation

let firebaseBaseURLString = "https://coleslaw.firebaseio.com"

class FirebaseClient {

  private var refCache = [String: Firebase!]()

  class var sharedInstance: FirebaseClient {
    struct Static {
      static let instance = FirebaseClient()
    }

    return Static.instance
  }

  private func refWithPath(path: String) -> Firebase! {
    let fullPath = firebaseBaseURLString + path
    if let ref = refCache[fullPath] {
      return ref
    } else {
      let newRef = Firebase(url:  fullPath)
      refCache[fullPath] = newRef
      return newRef
    }
  }

  func writeNewCard(card: Card) {
    let demoCardsRef = refWithPath("/games/demo/cards")
    let newCardRef = demoCardsRef.childByAutoId()
    newCardRef.setValue(card.toDict())
  }

  func getCards(gameName: String, withClosure closure: (([Card]!) -> Void)) {
    let cardsRef = refWithPath("/games/\(gameName)/cards")

    cardsRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) -> Void in
      var cards = [Card]()
      let values = snapshot.value as! [String: [String: String]]
      for (_, object) in values {
        print(object["title"])
        cards.append(Card(title: object["title"]!))
      }
      closure(cards)
    }
  }

  func getAllGameNames(withClosure closure: (([String]!) -> Void)) {
    let gamesRef = refWithPath("/games")

    gamesRef.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) -> Void in
      var names = [String]()
      let values = snapshot.value as! NSDictionary
      for (key, _) in values {
        print(key)
        names.append(key as! String)
      }
      closure(names)
    }
  }

}