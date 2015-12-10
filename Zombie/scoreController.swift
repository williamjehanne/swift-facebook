//
//  scoreController.swift
//  Zombie
//
//  Created by William JEHANNE on 10/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ScoreController: UITableViewController, DataProtocol {
    
    @IBOutlet var myTableView: UITableView!
    var scores:[Score]! = []
    let data = ScoreSingleton()
    
    override func viewDidLoad() {
        data.askForDataWith(self)
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Chalkduster", size: 20)!], forState: UIControlState.Normal)
    }
    
    func didRetrieveData(scores: [Score]){
        print("je suis ici")
        self.scores = scores
        print(self.scores)
        self.myTableView.reloadData()
    }
    
    func goBack () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scores!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = self.myTableView.dequeueReusableCellWithIdentifier("cellule") as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell()
        }
        
        cell!.textLabel?.text = self.scores[indexPath.row].player
        cell!.detailTextLabel?.text = String(self.scores[indexPath.row].score)
        
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