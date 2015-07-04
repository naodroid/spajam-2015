//
//  CreateQuestionTableViewCell.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit

class MyQuizTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var quizLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(#category : String, hasQuiz : Bool) {
        self.categoryLabel.text = category
        self.quizLabel.text = hasQuiz ? "クイズ設定済み" : "クイズ未設定"
    }
}

