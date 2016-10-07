//
//  JJSubjectListDataProvider.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 28..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

protocol JJSubjectListDataProviderDataSource : NSObjectProtocol {
    func subjectForRowAt(indexPath: IndexPath) -> JJSubject
    func subjectFor(row:Int) -> JJSubject
    func numberOfRowIn(section: Int) -> Int
    func numberOfSections() -> Int
    func lastSeenSubject() -> JJSubject 
}


class JJSubjectListDataProvider: NSObject, JJSubjectListDataProviderDataSource {
    
    var subjectList : NSMutableArray
    
    override init() {
        subjectList = NSMutableArray()
        
        var wordDictionary: NSDictionary?
        
        if let path = Bundle.main.path(forResource:"words", ofType: "plist") {
            wordDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let dict = wordDictionary as NSDictionary! {
            let array: NSArray = dict["subjects"] as! NSArray
            var count = 0
            for dict in array {
                let holyDict = dict as! NSDictionary
                subjectList.add(JJSubject(subjectTitle: holyDict.object(forKey: "subjectTitle") as! String))
                let array2 = holyDict.object(forKey: "words") as! NSArray
                for word in array2{
                    let wordDict = word as! NSDictionary
                    (subjectList[count] as! JJSubject).add(holyWord: JJHolyWords(subtitle: wordDict.object(forKey: "title") as! String, words: wordDict.object(forKey: "words") as! String, address: wordDict.object(forKey: "address") as! String))
                }
                count += 1
            }
        }
    }
    
    func subjectForRowAt(indexPath: IndexPath) -> JJSubject {
        return subjectList[indexPath.row] as! JJSubject
    }
    
    func subjectFor(row:Int) -> JJSubject {
        return subjectList[row] as! JJSubject
    }
    func lastSeenSubject() -> JJSubject {
        return subjectList[0] as! JJSubject
    }
    
    func numberOfRowIn(section: Int) -> Int {
        return 5
    }
    
    func numberOfSections() -> Int {
        return 1
    }
}
