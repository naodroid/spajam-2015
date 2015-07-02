//
//  AutoLayoutUtil.swift
//  test
//
//  Created by 坂本　尚嗣 on 2014/11/28.
//  Copyright (c) 2014年 jp.jig. All rights reserved.
//

import UIKit


class AutoLayoutUtil {
    
    ////指定Viewの親Viewに対し、match_parentな制約を追加する
    ///あらかじめaddSubviewで親Viewの中に配置しておく必要があるので注意！
    class func addConstraintsAsMatchParent(view: UIView) {
        let superview = view.superview!
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let w = AutoLayoutUtil.createConstraitsToView(view, format: "|[view]|")
        let h = AutoLayoutUtil.createConstraitsToView(view, format: "V:|[view]|")
        
        superview.addConstraints(w)
        superview.addConstraints(h)
    }
    
    
    class func createConstraitsToView(view: UIView, format: String) -> Array<NSLayoutConstraint>
    {
        let views = ["view" : view]
        let array = NSLayoutConstraint.constraintsWithVisualFormat(format,
            options: nil,
            metrics: nil,
            views: views)
        return array as! Array<NSLayoutConstraint>
    }
    
    
    class func findHeightContraint(view : UIView) -> NSLayoutConstraint? {
        return self.findSelfConstraint(view, attribute: .Height)
    }
    
    private class func findSelfConstraint(view: UIView,  attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let array = view.constraints() as! Array<NSLayoutConstraint>
        for c in array {
            if (c.firstAttribute == attribute) {
                return c;
            }
        }
        return nil;
    
    }
}


