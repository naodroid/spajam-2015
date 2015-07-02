//
//  EventBus.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/11/26.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//

import UIKit

//イベントの送信を担うクラス
//1)AbstractEventを継承したイベントクラスを作る (AEventとする）
//2)イベントを受け取りたいオブジェクトで、 AEvent.register(self, block) する
//3)EventBus.sendEventでAEventを送信
//4)registerした block が呼び出される
//5)unregisterで解除
//6)register時のObjectはweak保持されているので、unregisterしなくても大丈夫なはず...
//注意：現状、登録イベントのSubclassはイベント通知されない
class EventBus : NSObject {
    //イベントのクラス名をキーにして、イベント受信オブジェクト一覧を保持するDict
    private var registerDict = Dictionary<String, Array<WeakEventHolder>>()
    
    private override init() {
        super.init()
    }
    
    
    //内部処理用なので直接呼び出さないこと！ かならず各イベントクラスの register　経由でよびだす！
    func register(eventMetaName: String, object: NSObject, block: AbstractEvent -> Void) {
        onMainThread {
            let key = eventMetaName
            
            var arr = self.registerDict[key]  //なぜか ?? でかくと動かない
            if arr == nil {
                arr = Array<WeakEventHolder>()
            }
            if var a = arr {
                let obj = WeakEventHolder(object: object, block: block)
                a.append(obj)
                self.registerDict[key] = a
            }
        }
    }
    
    //こっちは利用可能。登録されている全部のイベントからイベント解除する
    func unregister(object : AnyObject) {
        onMainThread {
            //全部のキーについて調べねばならないのが少し面倒
            let keys = self.registerDict.keys
            for key in keys {
                self.unregister(key, object: object)
            }
        }
    }
    ///内部処理用なので直接呼び出さないこと！ かならず各イベントクラスの unregister 経由で呼び出す！
    func unregister(eventMetaName: String, object: AnyObject) {
        //指定オブジェクトの削除。ついでに切れている弱参照も消す
        onMainThread {
            var list = self.registerDict[eventMetaName]
            if list != nil {
                let count = list!.count
                for var i = count - 1; i >= 0; i-- {
                    let holder = list![i]
                    if holder.holdingObject === object || holder.holdingObject == nil {
                        list!.removeAtIndex(i)
                    }
                }
                self.registerDict[eventMetaName] = list
            }
        }
    }
    
    
    ///イベントを送信する
    func sendEvent(event: AbstractEvent) {
        onMainThread {
            let key = NSStringFromClass(event.dynamicType)
            let list = self.registerDict[key]
            if list == nil {
                return;
            }
            let filtered = list!.filter() {$0.holdingObject != nil}
            for holder in filtered {
                holder.eventBlock?(event)
            }
        }
    }
    
    
    
    
    //MARK- static
    class func instance() -> EventBus {
        struct Singleton {
            static let instance = EventBus()
        }
        return Singleton.instance
    }
    class func sendEvent(event: AbstractEvent) {
        EventBus.instance().sendEvent(event)
    }
    class func register(eventMetaName: String , object: NSObject, block: AbstractEvent -> Void) {
        EventBus.instance().register(eventMetaName, object: object, block: block)
    }
    class func unregister(object: NSObject) {
        EventBus.instance().unregister(object)
    }
    class func unregister(eventMetaName: String, object: AnyObject) {
        EventBus.instance().unregister(eventMetaName, object: object)
    }
}


class WeakEventHolder : NSObject {
    
    private weak var holdingObject : NSObject? = nil
    private var eventBlock: (AbstractEvent -> Void)? = nil
    
    init(object : NSObject, block : AbstractEvent -> Void) {
        super.init()
        self.holdingObject = object
        self.eventBlock = block
    }
}
