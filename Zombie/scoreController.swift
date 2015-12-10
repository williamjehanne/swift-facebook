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

class ScoreController: UITableViewController {
    
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Chalkduster", size: 20)!], forState: UIControlState.Normal)
    }
    
    func goBack () {
        self.dismissViewControllerAnimated(true, completion: nil)
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