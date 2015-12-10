//
//  Score.swift
//  Zombie
//
//  Created by William JEHANNE on 10/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//

import Foundation

class Score : NSObject {
    var score:Int!
    var player:String?
    var date:String?
    
    init(score:Int, player:String, date:String) {
        self.score = score
        self.player = player
        self.date = date
    }
}