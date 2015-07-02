//
//  AbstractEvent.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/11/26.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//

import UIKit

class AbstractEvent: NSObject {
    
    let name : String
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    ///このイベントに登録する。現状のところ指定イベントのサブクラスイベントは通知されない
    class func register<T : AbstractEvent>(object: NSObject, _ block: T -> Void) {
        let c1 = NSStringFromClass(T)
        let c2 = NSStringFromClass(self)
        
        if c1 != c2 {
            fatalError("IllegalCall, The Method parameter doesn't equal to Class")
        }
        //T->Void と Abstract->Void のキャストをしないとビルドが通らなかった
        let wrapped = {
            (event: AbstractEvent) in
            block(event as! T)
        }
        EventBus.register(c1, object: object, block: wrapped)
    }
    ///このイベントから登録解除する。
    class func unregister(object: AnyObject) {
        EventBus.unregister(NSStringFromClass(self), object: object)
    }
}

