//
//  ViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/02.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !User.hasAccount() {
            let vc = PresentationViewController.createVC()
            let nc = UINavigationController(rootViewController: vc)
            nc.setNavigationBarHidden(true, animated: false)
            self.presentViewController(nc, animated: true, completion: nil)
        
        } else if MyQuizList.instance().list.count == 0 {
            let vc = MyQuizViewController.createVC(false)
            let nc = UINavigationController(rootViewController: vc)
            nc.setNavigationBarHidden(true, animated: false)
            self.presentViewController(nc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: event
    
    @IBAction func didClickDebug(sender: AnyObject) {
        //特定ユーザIDを決め打ちで取得する
        accessToUserQuiz(83)
    }
    private func accessToUserQuiz(userId : Int) {
        Api.quizListProcess(userId).then {(quizList) -> Void in
            if let quiz = self.isMatchCategory(quizList) {
                let vc = OhakoReceivedViewController.createVCWithQuiz(quiz)
                let nc = UINavigationController(rootViewController: vc)
                nc.setNavigationBarHidden(true, animated: false)
                
                self.addChildViewController(nc)
                nc.didMoveToParentViewController(self)
                self.view.addSubview(nc.view)
                vc.startEnterAnimation()
            }
        }
    }
    private func isMatchCategory(quizList : [Quiz]) -> Quiz? {
        let myList = MyQuizList.instance().list
        return quizList.reduce(nil) {(value : Quiz?, quiz) -> Quiz? in
            if (value != nil) {
                return value
            }
            let c = quiz.category
            if myList[c] != nil {
                return quiz
            }
            return nil
        }
    }
    
    
    
    
    
    
}

