//
//  OhakoReceivedViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import PromiseKit

class OhakoReceivedViewController: UIViewController {
    
    private var quiz : Quiz! = nil
    
    @IBOutlet weak var textLabel: UILabel!
    
    
    
    class func createVCWithQuiz(quiz : Quiz) -> OhakoReceivedViewController {
        let sb = UIStoryboard(name: "Answer", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! OhakoReceivedViewController
        vc.quiz = quiz
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = self.quiz.userName
        self.textLabel.text = "\(name)さんの\nオハコが届きました"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startEnterAnimation() {
        self.view.transform = CGAffineTransformMakeTranslation(0, 320)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.transform = CGAffineTransformIdentity
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
        let data = AnsweredData(userId: self.quiz.userId, category: self.quiz.category)
        AnsweredList.instance().list.append(data)
        AnsweredList.instance().writeToFile()
        
        let vc = AnswerViewController.createVCWithQuiz(self.storyboard!, quiz: self.quiz)
        let parent = self.parentViewController!
        
        self.willMoveToParentViewController(nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        
        parent.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func didClickCancel(sender: AnyObject) {
        self.startExitAnimation()
        
        let data = AnsweredData(userId: self.quiz.userId, category: self.quiz.category)
        AnsweredList.instance().list.append(data)
        AnsweredList.instance().writeToFile()
        
        EventBus.sendEvent(TimerEvent(running: true))
    }
}
