//
//  OhakoReceivedViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class OhakoReceivedViewController: UIViewController {
    
    private var quiz : Quiz! = nil
    
    class func createVCWithQuiz(quiz : Quiz) -> OhakoReceivedViewController {
        let sb = UIStoryboard(name: "Answer", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! OhakoReceivedViewController
        vc.quiz = quiz
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
        let vc = AnswerViewController.createVCWithQuiz(self.storyboard!, quiz: self.quiz)
        self.addChildViewController(vc)
        vc.didMoveToParentViewController(self)
        self.view.addSubview(vc.view)
        vc.view.frame = self.view.bounds
    }
    
    @IBAction func didClickCancel(sender: AnyObject) {
        self.startExitAnimation()
    }
}
