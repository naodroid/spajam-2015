//
//  PromiseKitExt.swift
//  weather_sample
//
//  Created by 坂本　尚嗣 on 2015/04/21.
//  Copyright (c) 2015年 坂本　尚嗣. All rights reserved.
//

import Foundation
import PromiseKit

extension Promise {
    
    //thenに関数を渡すとうまく動作してくれない。どうも第一引数がデフォルト値付きなのでうまくビルド出来ない模様
    //しょうがないので第一引数なしの自作をつくる
    func after<U>(body: T -> Promise<U>) -> Promise<U> {
        return self.then(on: dispatch_get_main_queue(), body)
    }
    func after<U>(body: T -> U) -> Promise<U> {
        return self.then(on: dispatch_get_main_queue(), body)
    }
}


func try<T>(block: Void -> Promise<T>) -> Promise<T> {
    return block()
}


//MARK: customize operation

infix operator --> {
associativity left
precedence 91
}
public func --> <T, U>(left: Promise<T>, right: T -> Promise<U>) -> Promise<U> {
    return left.after(right)
}
public func --> <T, U>(left: Promise<T>, right: T -> U) -> Promise<U> {
    return left.after(right)
}


infix operator -=> {
associativity left
precedence 91
}
public func -=> <T> (left: Promise<T>, right: NSError -> Void) {
    left.catch(policy: CatchPolicy.AllErrorsExceptCancellation, right)
}


extension NSError {
    public class func userAbortedError() -> NSError {
        return NSError(domain: PMKErrorDomain, code: -1, userInfo: nil)
    }
}

func waitPromise<T>(time : NSTimeInterval, value : T) -> Promise<T> {
    let (promise, fulfill, reject) = Promise<T>.defer()
    dispatchAfterOnMain(time) {
        fulfill(value)
    }
    return promise
}
