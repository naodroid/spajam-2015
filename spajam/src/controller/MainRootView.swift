//
//  MainRootView.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class MainRootView: UIView {
    
    
    var friends = [Friend]() {
        didSet {
            self.createViewsFromCurrentFriends()
        }
    }
    private var friendViews = [FriendBalloonView]()
    
    
    
    override init(frame : CGRect) {
        super.init(frame : frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    
    //View management
    //
    func createViewsFromCurrentFriends() {
        //remove current
        let views = self.subviews as! [UIView]
        views.foreach {
            $0.removeFromSuperview()
        }
        //
        self.friendViews = self.friends.map {
            let view = FriendBalloonView.createView()
            view.updateWithFriend($0)
            return view
        }
        self.friendViews.foreach {
            self.addSubview($0)
        }
    }
    //
    override func layoutSubviews() {
        //角度を決めて等分に配置する
        let count = self.friendViews.count
        if (count == 0) {
            return
        }
        let angle = 360 / count
        var start = Int(arc4random_uniform(360))
        
        let viewW = self.bounds.size.width
        let viewH = self.bounds.size.height
        
        let centerX = viewW / 2
        let centerY = viewH / 2
        
        self.friendViews.foreach {(view) in
            let a = start + angle + Int(arc4random_uniform(10)) - 5
            
            let dx = cos(Double(a) / 180.0 * M_PI)
            let dy = sin(Double(a) / 180.0 * M_PI)
            
            let cx = centerX + CGFloat(dx)
            let cy = centerY + CGFloat(dy)
            
            view.center = CGPointMake(cx, cy)
            
            start += angle
        }
    }
    
    
    

}
