//
//  CreateQuestionTableViewCell.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import SDWebImage

class MyQuizTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quizLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(#category : CategoryInfo, hasQuiz : Bool) {
        self.categoryLabel.text = category.name
        self.quizLabel.text = hasQuiz ? "クイズ設定済み" : "クイズ未設定"
        
        let url = NSURL(string : category.imageUrl)
        self.iconImageView.sd_setImageWithURL(url!)
    }
}

