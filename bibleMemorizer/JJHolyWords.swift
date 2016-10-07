//
//  JJHolyWords.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 30..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJHolyWords: NSObject {
    public var subtitle: String = ""
    public var words: String = ""
    public var address: String = ""
    public var memorizeRate: Int = 0
    
    init(subtitle: String, words: String, address: String) {
        self.subtitle = subtitle
        self.words = words
        self.address = address
    }
}
