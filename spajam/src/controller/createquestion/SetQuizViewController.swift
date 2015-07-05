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
    
    @IBOutlet var rankViews: [QuizRankChoiceView]!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var okButton: UIButton!
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
        
        self.loadingIndicator.stopAnimating()
        
        self.imageButtons.foreach {
            $0.addTarget(self, action: "didClickImageButton:", forControlEvents: .TouchUpInside)
            
            $0.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        }
        self.rankViews.foreach {(view) in
            view.didRankChange = {(rank) -> Void in
                let index = view.tag - 1
                let ans = self.myQuiz.answers[index]
                ans.rank = rank
                self.setupForCurrentQuiz()
            }
        }
        self.setupForCurrentQuiz()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupForCurrentQuiz() {
        let answers = self.myQuiz.answers
        let count = self.imageButtons.count
        var enabled = true
        for i in 0..<count {
            let img = self.imageButtons[i]
            let btn = self.rankViews[i]
            
            let ans = answers[i]
            
            if let image = ans.image {
                img.setTitle(nil, forState: .Normal)
                img.setImage(image, forState: .Normal)
            } else {
                img.setTitle("画像未設定", forState: .Normal)
                img.setImage(nil, forState: .Normal)
            }
            if ans.image == nil || ans.rank == nil {
                enabled = false
            }
            
            btn.rank = ans.rank
            btn.hidden = false
        }
        okButton.enabled = enabled
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
            self.willMoveToParentViewController(nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    
    //MARK: Event
    
    func didClickImageButton(sender : UIButton) {
        let index = sender.tag - 1
        self.startImageSelection(index)
    }
    
    func didClickRankButton(sender : UIButton) {
        let index = sender.tag - 1
        
        let ans = self.myQuiz.answers[index]
        if let img = ans.image {
            self.showRankActionSheet(index, image: img)
        } else {
            self.startImageSelection(index)
        }
        
    }
    @IBAction func didClickCancel(sender: AnyObject) {
        startExitAnimation()
    }
    //確定処理
    @IBAction func didClickOkButton(sender: AnyObject) {
        //全部未設定だったら何もしない
        let answers = self.validateAnswers()
        if answers.count < 4 {
            return
        }
        
        self.loadingIndicator.hidden = false
        self.loadingIndicator.startAnimating()
        self.okButton.enabled = false
        
        //なぜかprogresが出るまでに時間がかかる。よくわからないので処理遅延させる
        dispatchAfterOnMain(0.5) {
            Api.setQuiz(self.category, answers: answers).then {(result : String) -> Void in
                MyQuizList.instance().list[self.category] = self.myQuiz
                MyQuizList.instance().writeToFile()
                
                EventBus.sendEvent(MyQuizUpdatedEvent(myQuiz: self.myQuiz))
                self.startExitAnimation()
                self.loadingIndicator.stopAnimating()
                }.finally(on: dispatch_get_main_queue()) { () -> Void in
                    self.loadingIndicator.stopAnimating()
                    self.setupForCurrentQuiz()
            }
        }
    }
    func validateAnswers() -> [MyQuizAnswer] {
        return self.myQuiz.answers.filter {(ans) -> Bool in
            return ans.image != nil && ans.rank != nil
        }
        
    }
    
    //画像選択系
    func startImageSelection(index : Int) {
        PhotoUtil.imagePickPromise(self).then {(image : UIImage) -> Void in
            let resized = SetQuizViewController.resizeImage(image)
            let ans = self.myQuiz.answers[index]
            ans.image = image
            self.setupForCurrentQuiz()
        }
    }
    
    
    func showRankActionSheet(index : Int, image : UIImage) {
        let sheet = UIActionSheet()
        sheet.title = "ランク選択"
        sheet.addButtonWithTitle("師匠")
        sheet.addButtonWithTitle("同士")
        sheet.addButtonWithTitle("ニワカ")
        
        let ans = self.myQuiz.answers[index]
        
        sheet.promiseInView(self.view).then {(button : Int) -> Void in
            ans.rank = QuizRank(rawValue: button)
            ans.image = image
            self.setupForCurrentQuiz()
        }
    }
    private class func resizeImage(image : UIImage) -> UIImage {
        // リサイズ画像のサイズ
        let baseSize = image.size
        let size = CGSizeMake(baseSize.width / 4, baseSize.height / 4)
        
        UIGraphicsBeginImageContext(size);
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let ret = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return ret
    }
    
    


}
