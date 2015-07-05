//
//  AnsweredData.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation

/**
 *回答済みのデータを保持するクラス
*/

class AnsweredList {
    
    var list = [AnsweredData]()
    
    static var _instance : AnsweredList? = nil
    
    class func instance() -> AnsweredList {
        if (_instance == nil) {
            _instance = AnsweredList()
            _instance?.readFromFile()
        }
        return _instance!
    }
    
    private func readFromFile() {
        let path = FileUtil.filePathForName("answered_list")
        let list = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [AnsweredData]
        if let l = list {
            self.list = l
        }
    }
    func writeToFile() {
        let path = FileUtil.filePathForName("answered_list")
        NSKeyedArchiver.archiveRootObject(self.list, toFile: path)
    }
    
    func hasData(userId: Int, category: String) -> Bool {
        for data in self.list {
            if data.userId == userId && data.category == category {
                return true
            }
        }
        return false
    }
    
}
class AnsweredData : NSObject, NSCoding {
    let userId : Int
    let category : String
    
    init(userId: Int, category: String) {
        self.userId = userId
        self.category = category
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        self.userId = aDecoder.decodeIntegerForKey("userId")
        self.category = aDecoder.decodeObjectForKey("category") as! String
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.userId, forKey: "userId")
        aCoder.encodeObject(self.category, forKey: "category")
    }
}
