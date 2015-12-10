//
//  ViewController.swift
//  Zombie
//
//  Created by Pierre Kopaczewski on 08/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Alamofire

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var pointsLabel : UILabel?
    @IBOutlet var healthLabel : UILabel?
    @IBOutlet var board : Board?
    @IBOutlet var gameOverButton : UIButton?
    var auteur:String!

    var turns = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        
        self.initGame();
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : String = String(result.valueForKey("name")!)
                self.auteur = userName
                print("User Name is: \(userName)")
                let userEmail : String = String(result.valueForKey("email"))
                print("User Email is: \(userEmail)")
            }
        })
    }
    
    func initGame() {
        
        self.board!.centerPlayer()
        for _ in 0...Settings.initialZombiesNumber {
            self.board?.spawnNewZombie()
        }
        
        self.syncWithPlayer((self.board?.player)!)
        
        self.gameOverButton?.hidden = true
    }
    
    @IBAction func moveNorth() {
        print("player moved to the north")
        self.board?.player.moveTo(Direction.North, board: self.board!)
        self.turn()
    }
    
    @IBAction func moveSouth() {
        print("player moved to the south")
        self.board?.player.moveTo(Direction.South, board: self.board!)
        self.turn()
    }
    
    @IBAction func moveEast() {
        print("player moved to the east")
        self.board?.player.moveTo(Direction.East, board: self.board!)
        self.turn()
    }
    
    @IBAction func moveWest() {
        print("player moved to the west")
        self.board?.player.moveTo(Direction.West, board: self.board!)
        self.turn()
    }
    
    func turn() {
        
        self.board?.killZombiesUnderPlayer()
        
        self.board?.moveZombies()
        
        if ((self.turns % Settings.turnsBetweenZombieSpawn) == 0 ) {
            self.board?.spawnNewZombie()
        }
        
        self.board?.setNeedsDisplay()

        self.board?.checkIfplayerIsInDanger()
        
        self.syncWithPlayer((self.board!.player))

        if (self.board?.player.health < 1) {
            self.gameOver()
            return
        }
        
        self.pointsLabel?.text = "\(self.turns)"
        
        
        self.turns++
    }
    
    func saveScoreIfNeeded() {
        let highestScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        if (highestScore < self.turns) {
            NSUserDefaults.standardUserDefaults().setInteger(self.turns, forKey: "highscore")
            let author = NSUserDefaults.standardUserDefaults().objectForKey("currentauthor")
            NSUserDefaults.standardUserDefaults().setObject(author, forKey: "highscoreauthor")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }

    func syncWithPlayer(player : Player) {
        
        var healthString = ""
        if player.health < 1 {
            // ok
        } else {
            for _ in 1...player.health {
                healthString += "❤️"
            }
        }
        
        self.healthLabel?.text = healthString
    }
    
    func gameOver() {
        self.saveScoreIfNeeded()
        self.gameOverButton?.hidden = false
        
        let parameters = [
            "score": String(self.turns),
            "player": String(self.auteur!)
        ]
        
        Alamofire.request(.POST, "http://scenies.com/insset_api/services/zombie/publishScore.php",
            parameters: parameters)
        
        createButtonShareFacebook()
    }
    
    func createButtonShareFacebook() {
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "<INSERT STRING HERE>")
        content.contentTitle = "application zombie ! suprise ! Gros score : \(self.turns)"
        content.contentDescription = "Grosse description ici"
        content.imageURL = NSURL(string: "https://i.ytimg.com/vi/PI9yKr39vGI/maxresdefault.jpg")
        
        let button : FBSDKShareButton = FBSDKShareButton()
        button.shareContent = content
        button.frame = CGRectMake((UIScreen.mainScreen().bounds.width - 100) * 0.5, 50, 100, 25)
        self.view.addSubview(button)

    }
    
    @IBAction func leave () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
