//
//  JJSubject.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 28..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJSubject: NSObject {
    public var subjectTitle: String = ""
    public var wordList: NSMutableArray = NSMutableArray()
    public var memorizedWordsCount = 0
    public var lastSeenWord = 0
    
    init(subjectTitle: String) {
        self.subjectTitle = subjectTitle
    }
    
    func add(holyWord: JJHolyWords) -> Void {
        wordList.add(holyWord)
    }
    
    func holyWordsAt(index:Int) -> JJHolyWords {
        return wordList[index] as! JJHolyWords
    }
}
