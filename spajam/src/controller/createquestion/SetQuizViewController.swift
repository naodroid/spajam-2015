//
//  SetQuizViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class SetQuizViewController: UIViewController {

    //IB
    @IBOutlet var imageButtons: [UIButton]!
    
    @IBOutlet var rankButtons: [UIButton]!
    //
    private var category : String = ""
    private var myQuiz : MyQuiz! = nil
    
    //------------------
    class func createVC(storyboard : UIStoryboard, category : String) -> SetQuizViewController {
        let vc = storyboard.instantiateViewControllerWithIdentifier("SetQuiz") as! SetQuizViewController
        vc.category = category
        
        vc.myQuiz = MyQuizList.instance().list[category] ?? MyQuiz(category: category)
        
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageButtons.foreach {
            $0.addTarget(self, action: "didClickImageButton:", forControlEvents: .TouchUpInside)
        }
        self.rankButtons.foreach {
            $0.addTarget(self, action: "didClickRankButton:", forControlEvents: .TouchUpInside)
        }
        self.setupForCurrentQuiz()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupForCurrentQuiz() {
        let answers = self.myQuiz.answers
        let count = self.imageButtons.count
        for i in 0..<count {
            let img = self.imageButtons[i]
            let btn = self.rankButtons[i]
            
            if i < answers.count {
                let ans = answers[i]
                img.setTitle("", forState: .Normal)
                img.setImage(ans.image, forState: .Normal)
                btn.setTitle(ans.rank?.displayText(), forState: .Normal)
                btn.hidden = false
            } else {
                img.setTitle("選択肢未設定", forState: .Normal)
                img.setImage(nil, forState: .Normal)
                btn.hidden = true
            }
        }
        
    }
    
    //MARK: anim
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
    
    
    
    
    //MARK: Event
    
    func didClickImageButton(sender : UIButton) {
        let index = sender.tag - 1
        PhotoUtil.imagePickPromise(self).then {(image : UIImage) -> () in
        }
    }
    func didClickRankButton(sender : UIButton) {
        let index = sender.tag - 1
        
    }
    @IBAction func didClickOutside(sender: AnyObject) {
        startExitAnimation()
    }
    @IBAction func didClickOkButton(sender: AnyObject) {
    }
    
    


}
