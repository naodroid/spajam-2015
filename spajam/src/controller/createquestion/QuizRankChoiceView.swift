//
//  QuizRankChoiceView.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/05.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class QuizRankChoiceView: UIView {
    var rank : QuizRank? = nil {
        didSet {
            self.updateView()
        }
    }
    
    var didRankChange : ((QuizRank) -> Void)? = nil
    
    //IB
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    
    required init(coder aDecoder : NSCoder) {
        super.init(coder : aDecoder)
        
        self.inflateView()
    }
    
    private func inflateView() {
        let nib = UINib(nibName: "QuizRankChoiceView", bundle: nil)
        let arr = nib .instantiateWithOwner(self, options: nil)
        let view = arr[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    
    //
    func updateView() {
        let img1 = (rank == .Fickle) ? "ohako_kentei_setting_1_button_selected" : "ohako_kentei_setting_1_button_default"
        let img2 = (rank == .Friend) ? "ohako_kentei_setting_2_button_selected" : "ohako_kentei_setting_2_button_default"
        let img3 = (rank == .Teacher) ? "ohako_kentei_setting_3_button_selected" : "ohako_kentei_setting_3_button_default"
        if (button1 == nil) {
            return;
        }
        button1.setImage(UIImage(named:img1), forState: .Normal)
        button2.setImage(UIImage(named:img2), forState: .Normal)
        button3.setImage(UIImage(named:img3), forState: .Normal)
    }
   
    @IBAction func didClickButton1(sender: AnyObject) {
        self.rank = .Fickle
        if let block = self.didRankChange {
            block(.Fickle)
        }
    }
    @IBAction func didClickButton2(sender: AnyObject) {
        self.rank = .Friend
        if let block = self.didRankChange {
            block(.Friend)
        }
    }
    @IBAction func didClickButton3(sender: AnyObject) {
        self.rank = .Teacher
        if let block = self.didRankChange {
            block(.Teacher)
        }
    }
    
    
}
