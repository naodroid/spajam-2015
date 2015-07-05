//
//  Friend.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation
import SwiftyJSON

class Friend {
    let userId : Int
    let name : String
    let image : String
    let category : String
    let rank : QuizRank
    
    init(userId : Int, name: String, image: String, category: String, rank: QuizRank) {
        self.userId = userId
        self.name = name
        self.image = image
        self.category = category
        self.rank = rank
    }
    
    
    class func parse(json : JSON) -> Friend {
        let userId = json["user_id"].stringValue.toInt()!
        let name = json["name"].stringValue
        let image = json["image"].stringValue
        let category = json["category"].stringValue
        let rankText = json["rank"].stringValue
        let rank = quizRankForText(rankText)!
        
        return Friend(userId: userId, name: name, image: image, category: category, rank: rank)
    }
    
}