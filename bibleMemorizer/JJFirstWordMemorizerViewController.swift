//
//  JJFirstWordMemorizerViewController.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 30..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

class JJFirstWordMemorizerViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var problemView: UIView!
    @IBOutlet weak var choiceView: UIView!
    @IBOutlet weak var holyWordsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var answerCollectionView: UICollectionView!
    
    var problemString: String = ""
    var problemBlank: [String] = []
    var answerViewBlank: [String] = []
    var problem: JJProblem!
    var difficulty: Int = 0
    var correctAnswer: Int = 0
    var numberOfSolvedProblem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupProblem()
        
        self.answerCollectionView.register(UINib(nibName:"JJProblemAnswerCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: "answerCell")
        self.answerCollectionView.delegate = self
        self.answerCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    func nextDifficultyLevel() -> Void {
        self.numberOfSolvedProblem = 0
        if self.difficulty / 3 < 2 {
            self.difficulty += 1
            self.setupProblem()
            self.problem.holyWords.memorizeRate += 12
        } else if self.difficulty / 3 == 2{
            self.setupProblem(lastRound: true)
            self.difficulty = 9
            self.problem.holyWords.memorizeRate += 12
        } else {
            self.navigationController?.popViewController(animated: true)
            self.problem.holyWords.memorizeRate = 100
        }
        self.answerCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProblem(lastRound:Bool = false) -> Void {
        self.problemString = ""
        
        self.difficulty = self.problem.holyWords.memorizeRate / 12
        
        self.setupDifficulty(lastRound: lastRound)
        self.setupProblemText()
        self.addressLabel.text = problem.holyWords.address
        
        answerViewBlank = problemBlank.shuffled()
    }
    
    func setupDifficulty(lastRound:Bool) -> Void {
        var count: Int = 0

        if lastRound {
            problemBlank = problem.seperatedWords
            return
        }
        
        self.problemBlank = problem.blankWords
        while count < problem.blankWords.count / 3 * ( 2 - difficulty / 3 ) {
            count += 1
            problemBlank.remove(at: Int(arc4random_uniform(UInt32(problemBlank.count))))
        }
    }

    func setupProblemText() -> Void {
        
        var index: Int = 0
        var problemWordStart: Int = 0
        var problemWordLength: Int = 0
        var problemString: String = ""
        for word: String in problem.seperatedWords {
            if index < problemBlank.count && word == problemBlank[index] {
                if index < numberOfSolvedProblem {
                    index += 1
                    problemString.append(word)
                    problemString.append(" ")
                    continue
                }
                if index == numberOfSolvedProblem {
                    problemWordStart = problemString.characters.count
                    problemWordLength = word.characters.count * 2
                }
                for _ in word.characters {
                    problemString.append("__")
                }
                
                index += 1
            } else {
                problemString.append(word)
            }
            problemString.append(" ")
        }
        self.problemString = problemString
        self.holyWordsLabel.attributedText = self.attributedString(from: self.problemString, boldRange: NSMakeRange(problemWordStart, problemWordLength))
    }
    
    
    func attributedString(from string: String, boldRange: NSRange?) -> NSAttributedString {
        let fontSize = CGFloat(17.0)
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
        ]
        let boldAttribute = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize + 1.0),
            NSForegroundColorAttributeName: UIColor.red
            ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = boldRange {
            attrStr.setAttributes(boldAttribute, range: range)
        }
        return attrStr
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.answerViewBlank.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let collectionViewCell: JJProblemAnswerCollectionViewCell = self.answerCollectionView.dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath) as! JJProblemAnswerCollectionViewCell
        
        collectionViewCell.answerButton.setTitle(answerViewBlank[indexPath.row], for: .normal)
        collectionViewCell.tapped = {
            (cell: JJProblemAnswerCollectionViewCell) -> Void in
            if cell.answerButton.title(for: .normal) == self.problemBlank[self.numberOfSolvedProblem] {
                self.numberOfSolvedProblem += 1
                var count: Int = 0
                for word: String in self.answerViewBlank {
                    if cell.answerButton.title(for: .normal) == word {
                       self.answerViewBlank.remove(at: count)
                       break
                    }
                    count += 1
                }
                cell.removeFromSuperview()
                self.setupProblemText()
                if self.answerViewBlank.count == 0 {
                    self.nextDifficultyLevel()
                }
            }
        }
        
        return collectionViewCell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CGFloat(self.answerViewBlank[indexPath.row].characters.count) * 14.0 + 20.0, height: 60)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
