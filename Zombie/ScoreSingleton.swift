//
//  ScoreSingleton.swift
//  Zombie
//
//  Created by William JEHANNE on 10/12/2015.
//  Copyright © 2015 Pierre Kopaczewski. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ScoreSingleton {
    var delegate: DataProtocol?
    var listData: [Score] = []
    
    static var _instance: ScoreSingleton?
    static var instance: ScoreSingleton {
        get {
            if (_instance == nil) {
                _instance = ScoreSingleton()
            }
            
            return _instance!
        }
    }
    
    var _toilets: [Score]?
    var toilet: [Score] {
        get {
            if(_toilets == nil) {
                _toilets = fetchAllToilet()
            }
            
            return _toilets!
        }
    }
    
    func askForDataWith(delegate: DataProtocol) {
        
        self.delegate = delegate
        
        Alamofire.request(.GET, "http://scenies.com/insset_api/services/zombie/scores.json")
            .responseJSON { response in
                
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    
                    for i in 0..<json.count {
                        let score:Int = json[i]["score"].intValue
                        let player:String = json[i]["player"].stringValue
                        let date:String = json[i]["date"].stringValue

                                              
                        let toilet = Score(score:score, player:player, date:date)
                        self.listData.append(toilet)
                    }
                    
                    if let d = self.delegate{
                        d.didRetrieveData(self.listData)
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
        }
    }
    
    func fetchAllToilet()-> [Score] {
        
        let url = NSURL(string: "http://scenies.com/insset_api/services/zombie/scores.json")
        
        let data = NSData(contentsOfURL: url!)
        let json = JSON(data: data!)
        
        var scores = [Score]()
        
        for i in 0..<json.count {
            
            
            let score = Score(score: json[i]["score"].intValue, player: String(json[i]["player"]), date: String(json[i]["date"]))
            
            
            scores.append(score)
        }
        
        return scores
    }
}

protocol DataProtocol {
    func didRetrieveData(scores: [Score])
}