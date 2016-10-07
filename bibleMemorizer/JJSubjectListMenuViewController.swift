//
//  JJSubjectListMenuViewController.swift
//  bibleMemorizer
//
//  Created by Coupang on 2016. 9. 30..
//  Copyright © 2016년 Byoungho. All rights reserved.
//

import UIKit

class JJSubjectListMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellReuseIdentifier: String = "subjectListTableViewCell"
    
    var subjectListDataProvider: JJSubjectListDataProviderDataSource!
    
    var tableView: UITableView!
    var deemedView: UIView!
    var didMenuSelectedAt: ((Int) -> Void)!
    
    init(subjectListDataProviderDataSource: JJSubjectListDataProviderDataSource){
        self.subjectListDataProvider = subjectListDataProviderDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDeemedView()
        self.setupTableView()
        
        self.tableView.frame = CGRect(x: self.tableView.bounds.origin.x, y: -self.tableView.bounds.size.height, width:self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)
        self.deemedView.frame = CGRect(x: self.deemedView.bounds.origin.x, y: 64, width: self.deemedView.bounds.size.width, height: self.deemedView.bounds.size.height)
        
        self.deemedView.isHidden = true
        self.tableView.isHidden = true
        self.view.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func setupDeemedView() -> Void {
        let mainScreenSize: CGSize = UIScreen.main.bounds.size
        deemedView = UIView(frame: CGRect(x: 0, y: 64, width: mainScreenSize.width, height: mainScreenSize.height - 44))
        self.deemedView.alpha = 0.0
        deemedView.backgroundColor = UIColor.black
        
        UIApplication.shared.keyWindow?.addSubview(deemedView)
        UIApplication.shared.keyWindow?.bringSubview(toFront: deemedView)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("deemedViewTapped:"))
        tap.numberOfTapsRequired = 1
        deemedView.addGestureRecognizer(tap)
    }
    
    
    func setupTableView() -> Void {
        let tableMenuHeight: CGFloat = CGFloat(subjectListDataProvider.numberOfRowIn(section: 0) * 43) + 30.0
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.size.width, height: tableMenuHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = UIColor.clear
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName:"JJSubjectListTableViewCell", bundle: nil), forCellReuseIdentifier: JJSubjectListMenuViewController.cellReuseIdentifier)
        
        self.view.addSubview(self.tableView)
        self.deemedView.bringSubview(toFront: self.tableView)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didMenuSelectedAt(indexPath.row)
        self.switchMenuList()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return subjectListDataProvider.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjectListDataProvider.numberOfRowIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "주제별 말씀"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell: JJSubjectListTableViewCell = tableView.dequeueReusableCell(withIdentifier: JJSubjectListMenuViewController.cellReuseIdentifier) as! JJSubjectListTableViewCell
        
        let asciiCodeForA = 65
        tableViewCell.set(labelTitle: String(format: "%c", indexPath.row + asciiCodeForA) + ". " + subjectListDataProvider.subjectForRowAt(indexPath: indexPath).subjectTitle)
        
        return tableViewCell
    }

    func switchMenuList() -> Void {
        if self.view.isHidden {
            self.deemedView.isHidden = !self.deemedView.isHidden
            self.tableView.isHidden = !self.tableView.isHidden
            self.view.isHidden = !self.view.isHidden
            
            UIView.animate(withDuration: 0.3, animations: {
                self.deemedView.alpha = 0.5
                self.tableView.frame = CGRect(x: self.tableView.bounds.origin.x, y: 64, width:self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)
                self.deemedView.frame = CGRect(x: self.deemedView.bounds.origin.x, y: 64 + self.tableView.bounds.size.height, width: self.deemedView.bounds.size.width, height: self.deemedView.bounds.size.height)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.deemedView.alpha = 0.0
                self.tableView.frame = CGRect(x: self.tableView.bounds.origin.x, y: -self.tableView.bounds.size.height, width:self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)
                self.deemedView.frame = CGRect(x: self.deemedView.bounds.origin.x, y: 64, width: self.deemedView.bounds.size.width, height: self.deemedView.bounds.size.height)
                
            }) { (complete:Bool) in
                self.deemedView.isHidden = !self.deemedView.isHidden
                self.tableView.isHidden = !self.tableView.isHidden
                self.view.isHidden = !self.view.isHidden
            }
        }
    }
    
    @objc(deemedViewTapped:)
    func deemedViewTapped(sender: UITapGestureRecognizer)
    {
        self.switchMenuList()
    }

}
