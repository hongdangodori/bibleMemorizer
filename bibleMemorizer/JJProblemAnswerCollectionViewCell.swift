//
//  JJProblemAnswerCollectionViewCell.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 10. 6..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJProblemAnswerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var answerButton: UIButton!
    var tapped: ((JJProblemAnswerCollectionViewCell) -> Void)!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func tapped(_ sender: AnyObject) {
        self.tapped(self)
    }

}
