//
//  Question.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

func quizRankForText(text : String) -> QuizRank? {
    switch (text) {
    case "teacher":
        return QuizRank.Teacher
    case "friend":
        return QuizRank.Friend
    case "ficker":
        return QuizRank.Fickle
    default:
        return nil
    }
}



enum QuizRank : Int {
    //師匠、同士、ニワカ
    case Teacher = 0
    case Friend = 1
    case Fickle = 2
    
    
    func displayText() -> String {
        switch self {
        case .Teacher:
            return "師匠"
        case .Friend:
            return "同士"
        case .Fickle:
            return "ニワカ"
        }
    }
    func apiText() -> String {
        switch self {
        case .Teacher:
            return "teacher"
        case .Friend:
            return "friend"
        case .Fickle:
            return "fickle"
        }
    }
}

class MyQuiz : NSObject, NSCoding {
    var category : String = ""
    var answers = [MyQuizAnswer]()
    
    override init() {
        super.init()
    }
    init(category : String) {
        self.category = category
        self.answers = [
            MyQuizAnswer(),
            MyQuizAnswer(),
            MyQuizAnswer(),
            MyQuizAnswer(),            
        ]
    }
    
    required init(coder aDecoder: NSCoder) {
        self.category = aDecoder.decodeObjectForKey("category") as! String
        self.answers = aDecoder.decodeObjectForKey("answers") as! [MyQuizAnswer]
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeObject(self.answers, forKey: "answers")
    }
}
class MyQuizAnswer : NSObject, NSCoding {
    var rank : QuizRank? = nil
    var image : UIImage? = nil
    
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let rankInt = aDecoder.decodeIntegerForKey("rank")
        self.rank = QuizRank(rawValue: rankInt)
        self.image = aDecoder.decodeObjectForKey("image") as? UIImage
    }
    func encodeWithCoder(aCoder: NSCoder) {
        if let rank = self.rank {
            aCoder.encodeInteger(rank.rawValue, forKey: "rank")
        }
        if let img = self.image {
            aCoder.encodeObject(img, forKey: "image")
        }
    }
}



class MyQuizList {
    var list = [String : MyQuiz]()
    
    static var _instance : MyQuizList? = nil
    
    
    class func instance() -> MyQuizList {
        if (_instance == nil) {
            _instance = MyQuizList()
            _instance?.readFromFile()
        }
        return _instance!
    }
    
    private func readFromFile() {
        let path = FileUtil.filePathForName("myquizlist")
        let data : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        if let l = data as? [String : MyQuiz] {
            self.list = l
        } else {
            self.list = [String : MyQuiz]()
        }
    }
    func writeToFile() {
        let path = FileUtil.filePathForName("myquizlist")
        NSKeyedArchiver.archiveRootObject(self.list, toFile: path)
    }
}


