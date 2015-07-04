//
//  AutoScaleView.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class AutoScaleView: UIView {

    
    override init(frame : CGRect) {
        super.init(frame: frame)
        initializeScale()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        initializeScale()
    }
    
    private func initializeScale() {
        let w = CGFloat(320)
        let h = CGFloat(568)
        
        let bounds = UIScreen.mainScreen().bounds
        let scale = bounds.size.width / w
        self.transform = CGAffineTransformMakeScale(scale, scale)
    }
    
    
}
