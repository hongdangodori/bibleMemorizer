//
//  JJSubjectListTableViewCell.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 28..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJSubjectListTableViewCell: UITableViewCell {

    @IBOutlet weak var subjectTitleLabel: UILabel!

    func set(labelTitle:String) -> Void {
        subjectTitleLabel.text = labelTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
