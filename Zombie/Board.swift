//
//  Board.swift
//  Board
//
//  Created by Pierre Kopaczewski on 20/08/2015.
//  Copyright © 2015 PierreKopa. All rights reserved.
//

import UIKit

class Board: UIView {
    
    var width = 10
    var height = 15
    
    var player:Player = Player()
    var zombies:[Zombie] = []
    
    // logic
    func centerPlayer () {
        self.player.position = (Int(self.width/2),Int(self.height/2))
    }
    
    func spawnNewZombie() {
        let zombie = Zombie()
        self.zombies.append(zombie)
        zombie.position = (Int(arc4random_uniform(UInt32(self.width))),Int(arc4random_uniform(UInt32(self.height))))
        
    }
    
    func moveZombies () {
        for zombie in self.zombies {
            zombie.randomMove(self)
        }
    }
    
    // draw
    override func drawRect(rect: CGRect) {
        
        for y in 0...self.height { // lines
            for x in 0...self.width { // columns
                let rand = Double(arc4random_uniform(UInt32(6)))
                UIColor(white: CGFloat(((248.0+rand)/255.0)), alpha: 1).set()
                UIRectFill(self.rectForCoordinate(x, y:y))
            }
        }
        
        UIColor.brownColor().set()
        for zombie in self.zombies {
            UIRectFill(self.rectForCoordinate(zombie.position.0, y:zombie.position.1))
        }
        
        UIColor.blueColor().set()
        UIRectFill(self.rectForCoordinate(self.player.position.0, y:self.player.position.1))

    }
    
    // geometry
    func squareSize() -> CGSize {
        return CGSizeMake(32, 32)
    }
    
    func rectForCoordinate(x : Int, y : Int) -> CGRect {
        
        let squareSize = self.squareSize()
        
        return CGRectMake(CGFloat(x)*squareSize.width, CGFloat(y)*squareSize.height, squareSize.width, squareSize.height)
    }
    
}