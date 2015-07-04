//
//  MyQuizUpdatedEvent.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import Foundation

class MyQuizUpdatedEvent : AbstractEvent {
    let myQuiz : MyQuiz
    init(myQuiz : MyQuiz) {
        self.myQuiz = myQuiz
        super.init(name: "MyQuizUpdatedEvent")
    }
}