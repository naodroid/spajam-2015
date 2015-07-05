//
//  Friend.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation
import SwiftyJSON

class Friend : NSObject, NSCoding {
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
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeIntegerForKey("userId")
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.image = aDecoder.decodeObjectForKey("image") as! String
        self.category = aDecoder.decodeObjectForKey("category") as! String
        let rank = aDecoder.decodeIntegerForKey("rank")
        self.rank = QuizRank(rawValue: rank)!
        super.init()
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.userId, forKey: "userId")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.image, forKey: "image")
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeInteger(self.rank.rawValue, forKey: "rank")
    }
    
    
    
    
    class func parse(json : JSON) -> Friend {
        let userId = json["user_id"].stringValue.toInt()!
        let name = json["name"].stringValue
        let image = json["image"].stringValue
        let category = json["category"].stringValue
        let rankText = json["rank"].stringValue
        let rank : QuizRank?
        if let raw = rankText.toInt() {
            rank = QuizRank(rawValue: raw)
        } else {
            rank = quizRankForText(rankText)
        }
        let useRank = rank ?? QuizRank.Friend
        
        return Friend(userId: userId, name: name, image: image, category: category, rank: useRank)
    }
}

class AnsweredFriendList {
    var list = [Friend]()
    
    static var _instance : AnsweredFriendList? = nil
    
    class func instance() -> AnsweredFriendList {
        if (_instance == nil) {
            _instance = AnsweredFriendList()
            _instance?.readFromFile()
        }
        return _instance!
    }
    
    private func readFromFile() {
        let path = FileUtil.filePathForName("answered_friend_list")
        let list = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Friend]
        if let l = list {
            self.list = l
        }
    }
    func writeToFile() {
        let path = FileUtil.filePathForName("answered_friend_list")
        NSKeyedArchiver.archiveRootObject(self.list, toFile: path)
    }

}
