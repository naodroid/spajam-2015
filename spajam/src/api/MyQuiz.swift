//
//  Question.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit



class MyQuiz : NSObject, NSCoding {
    var category : String = ""
    var images = [UIImage]()
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        category = aDecoder.decodeObjectForKey("category") as! String
        images = aDecoder.decodeObjectForKey("images") as! [UIImage]
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.category, forKey: "category")
        aCoder.encodeObject(self.images, forKey: "images")
    }
}
class MyQuizList {
    var list = [MyQuiz]()
    
    static var _instance : MyQuizList? = nil
    
    
    class func instance() -> MyQuizList {
        if (_instance == nil) {
            _instance = MyQuizList()
        }
        return _instance!
    }
    
    private func readFromFile() {
        let path = FileUtil.filePathForName("myquizlist")
        let data : AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        if let l = data as? [MyQuiz] {
            self.list = l
        } else {
            self.list = [MyQuiz]()
        }
    }
    func writeToFile() {
        let path = FileUtil.filePathForName("myquizlist")
        NSKeyedArchiver.archiveRootObject(self.list, toFile: path)
    }
}


