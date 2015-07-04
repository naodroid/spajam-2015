//
//  User.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/05/30.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation
import SwiftyJSON


var _owner : User? = nil

class User {
    let userId : String
    let name : String?
    let imageUrl : String?
    
    init(userId: String, name : String?, imageUrl: String?) {
        self.userId = userId
        self.name = name
        self.imageUrl = imageUrl
    }
    init(userId : String) {
        self.userId = userId
        self.name = nil
        self.imageUrl = nil
    }
    
    
    ///自分自身を返す。存在しないときnil
    class func owner() -> User {
        if (_owner == nil) {
            _owner = readOwnerInfo()
        }
        return _owner!
    }
    //オーナー情報をもっているかどうか
    class func hasAccount() -> Bool {
        if (_owner == nil) {
            _owner = readOwnerInfo()
        }
        return _owner != nil
    }
    
    class func registerAsOwner(user : User) {
        _owner = user
        writeToFile()
    }
    //File I/O
    private class func readOwnerInfo() -> User? {
        let path = FileUtil.filePathForName("owenr_info")
        let dict = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? NSDictionary
        
        switch dict {
        case .Some(let d):
            return User.fromDict(d)
        case .None:
            return nil
        }
    }
    private class func writeToFile() {
        if let o = _owner {
            let dict = o.toDictionary()
            let path = FileUtil.filePathForName("owenr_info")
            NSKeyedArchiver.archiveRootObject(dict, toFile: path)
        }
    }
    
    //MARK: JSON
    class func parse(json : JSON) -> User {
        let userId = json["id"].stringValue
        let name = json["name"].string
        let imageUrl = json["icon_url"].string
        
        if let n = name {
            return User(userId: userId, name: n, imageUrl: imageUrl)
        }
        return User(userId: userId)
    }
    func toDictionary() -> NSDictionary {
        var dict = NSMutableDictionary()
        dict["userId"] = self.userId
        if let n = self.name {
            dict["name"] = n
        }
        if let img = self.imageUrl {
            dict["imageUrl"] = img
        }
        return dict
    }
    class func fromDict(dict : NSDictionary) -> User {
        let userId = dict["userId"] as! String
        let name = dict["name"] as? String
        let imageUrl = dict["imageUrl"] as? String
        return User(userId: userId, name: name, imageUrl: imageUrl)
    }
    
    
    
    
    
    
}

