//
//  Quiz.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation
import SwiftyJSON

class Quiz {
    let userId : Int
    let userName : String
    let category : String
    let answers : [QuizAnswer]
    
    init(userId: Int, userName : String, category : String, answers : [QuizAnswer]) {
        self.userId = userId
        self.userName = userName
        self.category = category
        self.answers = answers
    }
    
    class func parse(userId: Int, userName: String, json : JSON) -> Quiz {
        let category = json["category"].stringValue
        let array = json["answers"].array!
        let answers = array.map(QuizAnswer.parse)
        return Quiz(userId: userId, userName: userName, category: category, answers: answers)
    }
}
class QuizAnswer {
    let rank : QuizRank
    let imageUrl : String
    
    init(rank : QuizRank, imageUrl : String) {
        self.rank = rank
        self.imageUrl = imageUrl
    }
    class func parse(json : JSON) -> QuizAnswer {
        println("JS:\(json)")
        
        let rankText = json["rank"].stringValue
        let rank = quizRankForText(rankText)!
        let imageUrl = json["image"].stringValue
        return QuizAnswer(rank: rank, imageUrl: imageUrl)
    }
}
