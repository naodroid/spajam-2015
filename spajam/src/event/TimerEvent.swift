//
//  TimerEvent.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class TimerEvent: AbstractEvent {
    let running : Bool
    
    init(running : Bool) {
        self.running = running
        super.init(name : "TimerEvent")
    }
}
