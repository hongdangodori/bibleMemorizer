//
//  JJWordMemorizerViewController.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 29..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJWordMemorizerViewController: UIViewController {

    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var holyWordsLabel: UILabel!
    
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var progressBar: UIView!
    
    @IBOutlet weak var memorizeRateLabel: UILabel!
    
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var currentPageNumberLabel: UILabel!

    @IBOutlet weak var totalPageNumberLabel: UILabel!
    var menuViewController: JJSubjectListMenuViewController!
    
    
    let subjectListDataProvider: JJSubjectListDataProviderDataSource = JJSubjectListDataProvider()
    var subject: JJSubject? = nil
    var currentPage: Int = 0
    var holyWord: JJHolyWords!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subject = self.subjectListDataProvider.lastSeenSubject()
        
        self.setupViews()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupContentViewWith(holyWords: self.holyWord)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews() -> Void {
        menuViewController = JJSubjectListMenuViewController(subjectListDataProviderDataSource: subjectListDataProvider)
        self.addChildViewController(menuViewController)
        self.view.addSubview(menuViewController.view)
        
        self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        self.prevButton.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        
        menuViewController.didMove(toParentViewController: self)
        menuViewController.didMenuSelectedAt = {
            (row: Int) -> Void in
            self.subject = self.subjectListDataProvider.subjectFor(row: row)
            self.navigationItem.title = self.subject!.subjectTitle
            self.currentPage = self.subject!.lastSeenWord
            self.setupPaginationStatus()
            self.holyWord = self.subject!.wordList[self.subject!.lastSeenWord] as! JJHolyWords
            self.setupContentViewWith(holyWords: self.holyWord)
        }
        
        self.navigationItem.title = subject!.subjectTitle
        self.setupPaginationStatus()
        self.holyWord = subject!.wordList[currentPage] as! JJHolyWords
    }
    
    func setupPaginationStatus() -> Void {
        self.prevButton.isHidden = currentPage == 0
        self.nextButton.isHidden = currentPage == subject!.wordList.count - 1
        self.currentPageNumberLabel.text = String(currentPage + 1)
        self.totalPageNumberLabel.text = String(self.subject!.wordList.count)
        self.subject?.lastSeenWord = currentPage
    }
    
    func setupContentViewWith(holyWords: JJHolyWords) -> Void {
        self.subtitleLabel.text = holyWords.subtitle as String
        self.holyWordsLabel.text = holyWords.words as String
        self.address.text = holyWords.address as String
        self.setupProgressBar(memorizeRate: holyWords.memorizeRate)
    }
    
    func setupProgressBar(memorizeRate: Int) -> Void {
        self.memorizeRateLabel.text = String.init(format: "%d", memorizeRate)
        let windowWidth: CGFloat = UIScreen.main.bounds.size.width
        self.progressBarWidthConstraint.constant = (windowWidth - 120) / 100 * CGFloat(memorizeRate)
    }
    
    @IBAction func nextButtonTapped(_ sender: AnyObject) {
        currentPage += 1
        setupContentViewWith(holyWords: subject!.wordList[currentPage] as! JJHolyWords)
        self.holyWord = subject!.wordList[currentPage] as! JJHolyWords
        self.setupPaginationStatus()
    }
    
    @IBAction func prevButtonTapped(_ sender: AnyObject) {
        currentPage -= 1
        setupContentViewWith(holyWords: subject!.wordList[currentPage] as! JJHolyWords)
        self.holyWord = subject!.wordList[currentPage] as! JJHolyWords
        self.setupPaginationStatus()
    }
    
    @IBAction func menuButtonTapped(_ sender: AnyObject) {
        self.menuViewController.switchMenuList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showFirstMemorizeStep") {
            let problemViewController: JJFirstWordMemorizerViewController = segue.destination as! JJFirstWordMemorizerViewController
            problemViewController.problem = JJProblemGenerator.generateProblemWith(holyWords: subject!.wordList[currentPage] as! JJHolyWords)
        }
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
