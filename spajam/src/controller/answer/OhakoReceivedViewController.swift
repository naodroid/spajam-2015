//
//  OhakoReceivedViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class OhakoReceivedViewController: UIViewController {

    
    class func createVC() -> OhakoReceivedViewController {
        let sb = UIStoryboard(name: "Answer", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! OhakoReceivedViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startEnterAnimation() {
        self.view.alpha = 0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 1
        })
    }
    func startExitAnimation() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
            
        }) { (finished) -> Void in
            self.view.removeFromSuperview()
            self.willMoveToParentViewController(nil)
            self.removeFromParentViewController()
        }
    }
        

    @IBAction func didClickOpen(sender: AnyObject) {
    }
    
    @IBAction func didClickCancel(sender: AnyObject) {
        self.startExitAnimation()
    }
}
