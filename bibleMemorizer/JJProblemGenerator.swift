//
//  JJProblemGenerator.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 10. 4..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

extension String {
    func isImportantHolyWord() -> Bool {
        return self.contains("을") || self.contains("가") || self.contains("이") || self.contains("께") || self.contains("하") || self.contains("찬") || self.contains("는") || self.contains("은") || self.contains("의") || self.contains("고") || self.contains("못") || self.contains("도") || self.contains("로") || self.contains("한") || self.contains("리") || self.contains("를")
    }
}


class JJProblemGenerator: NSObject {
    static func generateProblemWith(holyWords: JJHolyWords) -> JJProblem {
        let problem: JJProblem = JJProblem()
        problem.seperatedWords = holyWords.words.components(separatedBy: " ")
        
        for word: String in problem.seperatedWords {
            if word.isImportantHolyWord() {
                problem.blankWords.append(word)
            }
        }
        
        problem.holyWords = holyWords
        
        return problem
    }
}
