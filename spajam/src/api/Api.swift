//
//  Api.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/05/30.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON
import OMGHTTPURLRQ

let basePath = "http://api.spajam.tys11.net"


private var _cookieString : String? = nil

class Api {
    
    class func getPromise(path : String) -> Promise<NSData> {
        let (promise, fulfill, reject) = Promise<NSData>.defer()
        
        dispatchOnGlobal {
            let request = OMGHTTPURLRQ.GET(path, nil)
            request.HTTPShouldHandleCookies = true
            request.HTTPMethod = "GET"
            self.addCookiesToRequest(request, path : path)
            
            var error : NSError? = nil
            var response : NSURLResponse? = nil
            let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            
            dispatchOnMain {
                if let e = error {
                    reject(e)
                } else if let d = data {
                    self.checkCookie(path, response: response)
                    fulfill(d)
                } else {
                }
            }
        }
        return promise
    }
    class func postPromise(path : String, dict : [String : String]) -> Promise<NSData> {
        let (promise, fulfill, reject) = Promise<NSData>.defer()
        
        dispatchOnGlobal {
            let request = OMGHTTPURLRQ.POST(path, dict)
            request.HTTPShouldHandleCookies = true
            self.addCookiesToRequest(request, path : path)
            
            var error : NSError? = nil
            var response : NSURLResponse? = nil
            let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            
            dispatchOnMain {
                if let e = error {
                    reject(e)
                } else if let d = data {
                    self.checkCookie(path, response: response)
                    fulfill(d)
                } else {
                }
            }
        }
        return promise
    }
    
    private class func addCookiesToRequest(request : NSMutableURLRequest, path : String) {
        if _cookieString == nil {
           readCookie()
        }
        if let c = _cookieString {
            request.addValue(c, forHTTPHeaderField: "Cookie")
        }
    }
    
    private class func checkCookie(path: String, response : NSURLResponse?) {
        if let res = response as? NSHTTPURLResponse {
            let url = NSURL(string : path)!
            let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(res.allHeaderFields, forURL: url)
            let headers = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies)
            if let str = headers["Cookie"] as? String {
                if count(str) > 0 {
                    _cookieString = str
                    self.writeCookie()
                }
            }
            
        }
    }
    private class func readCookie() {
        let path = FileUtil.filePathForName("cookie")
        let data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? String
        if let c = data {
            _cookieString = c
        }
    }
    private class func writeCookie() {
        if let c = _cookieString {
            let path = FileUtil.filePathForName("cookie")
            NSKeyedArchiver.archiveRootObject(c, toFile: path)
        }
    }
    
    //----------------------------
    //ユーザ登録
    class func register(name : String) -> Promise<User> {
        let path = "\(basePath)/regist"
        let dict = ["name" : name]
        
        return postPromise(path, dict: dict)
            .then {(data: NSData) -> User in
                let json = JSON(data : data)
                let user = User.parse(json)
                User.registerAsOwner(user)
                return user
        }
    }
    
    
    
    
    
}