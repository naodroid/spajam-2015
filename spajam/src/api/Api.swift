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
            println("USERID:\(c)")
            request.addValue(c, forHTTPHeaderField: "Cookie")
        }
    }
    
    private class func checkCookie(path: String, response : NSURLResponse?) {
        if let res = response as? NSHTTPURLResponse {
            let url = NSURL(string : path)!
            
            println("ALL:\(res.allHeaderFields)")
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
        let nsstr = name as NSString
        let encoded = nsstr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let encodedStr = encoded!
        let dict = ["name" : encodedStr]
        
        return postPromise(path, dict: dict)
            .then {(data: NSData) -> User in
                let json = JSON(data : data)
                let user = User.parse(json)
                User.registerAsOwner(user)
                return user
        }
    }
    
    //クイズ追加
    class func setQuiz(category : String, answers : [MyQuizAnswer]) -> Promise<String> {
        
        let path = "\(basePath)/setquiz"
        
        
        let multipart = OMGMultipartFormData()
        
        multipart.addParameters(["category" : category])
        
        for i in 0..<answers.count {
            let img = answers[i].image!
            let rank = answers[i].rank!
            
            let data = UIImagePNGRepresentation(img)
            
            let imgParamName = "answer\(i + 1)Image"
            let imgFileName = "image\(i + 1).png"
            let rankParamName = "answer\(i + 1)Rank"
            
            multipart.addFile(data, parameterName : imgParamName, filename: imgFileName, contentType:"image/png")
            multipart.addParameters([rankParamName : rank.apiText()])
        }
        
        let req = OMGHTTPURLRQ.POST(path, multipart)
        self.addCookiesToRequest(req, path: path)
        req.addValue("keep-alive", forHTTPHeaderField: "Connection")
        
        return NSURLConnection.promise(req)
            .then {(data : NSData) -> String in
                return "Success"
        }
    }
    ///指定ユーザのクイズ一覧を取得
    class func quizListProcess(userId : Int) -> Promise<[Quiz]> {
        let path = "\(basePath)/quizlist?user_id=\(userId)"
        
        return getPromise(path).then {(data : NSData) -> [Quiz] in
            let json = JSON(data : data)
            return json.arrayValue.map(Quiz.parse)
        }
    }
    
    
    
    
}