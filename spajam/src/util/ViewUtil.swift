//
//  ViewUtil.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/11/26.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//

import UIKit
import QuartzCore

class ViewUtil {
    
    class func roundCorner(view: UIView, radius: CGFloat) {
        let layer = view.layer
        layer.cornerRadius = radius
    }
    class func addShadow(view: UIView, radius: CGFloat, alpha: Float) {
        let layer = view.layer
        layer.shadowRadius = radius
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowPath = UIBezierPath(rect: view.bounds).CGPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    
}


