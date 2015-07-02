//
//  Array+Ext.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/12/03.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//

import Foundation


extension Array {
    ///配列添字つきのMap
    func mapWithIndex<U>(block: (T, Int) -> U) -> Array<U> {
        var ret = Array<U>()
        let count = self.count
        for i in 0..<count {
            ret.append(block(self[i], i))
        }
        return ret
    }
    
    func foreachWithIndex(block:((T,Int) -> Void)) {
        for i in 0..<count {
            block(self[i], i)
        }
    }
    func foreach(block: T -> Void) {
        for item in self {
            block(item)
        }
    }
    
    //配列のうち、block通過後にnilになったものを除外する
    //便利な使い方  array.filterSome({$0 as? AnyClass})
    func filterSome<U>(block: T -> U?) -> Array<U> {
        var ret = Array<U>()
        for item in self {
            if let cast = block(item) {
                ret.append(cast)
            }
        }
        return ret
    }
    ///特定の型に型キャストする。正直 view.subviews用
    func castAs<U>(array: Array<U>) -> Array<U> {
        return ((self as Any) as! Array<U>)
    }
    
    
    //array[s..<e]だとsliceが帰ってきて、他の拡張が使えないのでrangeを作る。ただメモリ効率は悪い
    //s..<eと透過。start-lengthでないので注意
    func range(start: Int, _ end: Int) -> Array<T> {
        var ret = Array<T>()
        let slice = self[start..<end]
        for item in slice {
            ret.append(item)
        }
        return ret
    }
    
    func flatten<T>() -> Array<T> {
        let xs = (self as Any) as! Array<Array<T>>
        return xs.reduce(Array<T>()) { (x, acc) in x + acc }
    }
    //flattenの型推論がうまく動かない時用
    func flatten<U>(type: Array<U>) -> Array<U> {
        let xs = (self as Any) as! Array<Array<U>>
        return xs.reduce(Array<U>()) { (x, acc) in x + acc }
    }
    
    ///指定配列とのTuple化した配列を返す。配列長は長いほうが優先。短いほうは値がnilになる
    func zip<U>(source: Array<U>) -> Array<(T?, U?)> {
        let length = max(self.count, source.count)
        var ret = Array<(T?, U?)>()
        for i in 0..<length {
            let item1: T? = (i < self.count) ? self[i] : nil
            let item2: U? = (i < source.count) ? source[i] : nil
            let t: (T? , U?) = (item1, item2)
            ret.append(t)
        }
        return ret
    }
    func toSlice() -> ArraySlice<T> {
        return self[0..<self.count]
    }
    
    
}



///先頭から検索するfindはあるが、最後から走査するものがないので作る
//Array限定にしてるが特に困らないので無視
func findLast<T : Comparable>(array: Array<T>, value:T) -> Int? {
    //再帰関数にすればvarけせるが、そこまで頑張るメリットはないと判断...
    let count = array.count
    for var i = count - 1; i >= 0; i-- {
        if array[i] == value {
            return i
        }
    }
    return nil
}
