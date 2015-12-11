//
//  scoreController.swift
//  Zombie
//
//  Created by William JEHANNE on 10/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

class ScoreController: UITableViewController, DataProtocol {
    
    @IBOutlet var myTableView: UITableView!
    var scores = [DataScore]()
    var dataScores = [DataScore]()
    let data = ScoreSingleton()
    
    override func viewDidLoad() {
        data.askForDataWith(self)
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Chalkduster", size: 20)!], forState: UIControlState.Normal)
    }
    
    func didRetrieveData(scores: [Score]){
        self.savescore(scores)
        self.myTableView.reloadData()
    }
    
    func savescore(scores: [Score]) {
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        for s in scores {
            //2
            let score = NSEntityDescription.insertNewObjectForEntityForName("DataScore", inManagedObjectContext: managedContext) as? DataScore
            
            let player = NSEntityDescription.insertNewObjectForEntityForName("DataPlayer", inManagedObjectContext: managedContext) as? DataPlayer
            
            score?.score = String(s.score)
            player!.name = String(s.player!)
            score?.player = player
            
            //4
            do {
                try managedContext.save()
                //5
                self.dataScores.append(score!)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func goBack () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataScores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellule")
        
        let score = dataScores[indexPath.row]
        
        cell!.textLabel!.text = score.score
        cell!.detailTextLabel!.text = score.player!.name!
       

        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    func showResults() {
        Alamofire.request(.GET, "http://scenies.com/insset_api/services/zombie/scores.json")
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}