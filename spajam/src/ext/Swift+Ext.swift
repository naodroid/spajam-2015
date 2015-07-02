//
//  Swift+GCD.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/12/03.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//
// Swift自身の（クラスに関係ない）メソッドの拡張記述

import Foundation

//--------------------------------------------------
//MARK: GCD
///MainQueueにつむ
func dispatchOnMain(block: (Void -> Void)) {
    dispatch_async(dispatch_get_main_queue(), block)
}
//指定時間後にMainQueueで実行される
func dispatchAfterOnMain(delay: NSTimeInterval, block: (Void -> Void)) {
    let delayConverted = delay * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delayConverted))
    dispatch_after(time, dispatch_get_main_queue(), block)
}
//BackgroudQueueにつむ
func dispatchOnGlobal(block: (Void -> Void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}
//MainThreadだったらそのまま関数を実行、そうでなければ関数をMainQueueにつむ関数
func onMainThread(block: Void -> Void) {
    if (NSThread.isMainThread()) {
        block()
    } else {
        dispatchOnMain(block)
    }
}

//同一処理の繰り返し。for i in (0..<5)とか書くのが面倒なので（iが不要だとこの書き方が邪魔に感じる）
func repeat(n: Int, block : Void -> Void) {
    for i in 0..<n {
        block()
    }
}



//関数合成。
infix operator <- {
associativity right
precedence 90
}
func <- <A, B, C>(func2 : B -> C, func1 : A -> B) -> A -> C {
    return {(param : A) -> C in
        return func2(func1(param))
    }
}
func <- <A, B>(func2 : A -> B, param : A) -> B {
    return func2(param)
}
infix operator => {
associativity left
precedence 90
}
func => <A, B, C>(f1: A -> B, f2: B -> C) -> A -> C {
    return {(param : A) -> C in
        f2(f1(param))
    }
}

func => <A, B>(value: A, f: A -> B) -> B {
    return f(value)
}


//指定処理をN回繰り返す
func loop(count: Int, block: () -> Void) {
    for i in 0..<count {
        block()
    }
}


//--------------------------------------------------
//MARK: compare
//標準のmin, maxがnilを許容しないので、nil許容つきのmin/max
//どっちかがnilなら他方(nilでない方)、両方ともnilならnil、両方とも非nilならmin(max)を返す
func nullableMin<T : Comparable>(x: T?, y: T?) -> T? {
    if x == nil || y == nil {
        return x ?? y
    }
    return x < y ? x : y
}
func nullableMax<T : Comparable>(x: T?, y: T?) -> T? {
    if x == nil || y == nil {
        return x ?? y
    }
    return x > y ? x : y
}










