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
        //} else if MyQuizList.instance().list.count == 0 {
        } else {
            let vc = MyQuizViewController.createVC()
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
        //72のユーザIDを決め打ちで取得する
        Api.quizListProcess(72).then {(quizList) -> Void in
            println("RECEIVED:\(quizList)")
            
        }
    }
    
    
    
    
}

