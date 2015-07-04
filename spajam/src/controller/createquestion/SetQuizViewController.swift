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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
            
            let ans = answers[i]
            
            if let image = ans.image {
                img.setTitle(nil, forState: .Normal)
                img.setImage(image, forState: .Normal)
            } else {
                img.setTitle("画像未設定", forState: .Normal)
                img.setImage(nil, forState: .Normal)
            }
            btn.setTitle(ans.rank?.displayText(), forState: .Normal)
            btn.hidden = false
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
    @IBAction func didClickOutside(sender: AnyObject) {
        startExitAnimation()
    }
    @IBAction func didClickOkButton(sender: AnyObject) {
        //全部未設定だったら何もしない
        let answers = self.validateAnswers()
        if answers.count == 0 {
            startExitAnimation()
            return
        }
        
        self.loadingIndicator.startAnimating()
        
        Api.setQuiz(self.category, answers: answers).then {(result : String) -> Void in
            self.startExitAnimation()
            self.loadingIndicator.stopAnimating()
        }
    }
    func validateAnswers() -> [MyQuizAnswer] {
        return self.myQuiz.answers.filter {(ans) -> Bool in
            return ans.image != nil && ans.rank != nil
        }
        
    }
    
    
    func startImageSelection(index : Int) {
        PhotoUtil.imagePickPromise(self).then {(image : UIImage) -> Void in
            let resized = SetQuizViewController.resizeImage(image)
            self.showRankActionSheet(index, image: resized)
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
