//
//  CategorySelectionViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategorySelectionViewController: UIViewController,
                         UITableViewDataSource, UITableViewDelegate {

    ///IB
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var keywords = [String]()
    private var selections = [Bool]()
    
    ///
    class func createVC() -> CategorySelectionViewController {
        let sb = UIStoryboard(name: "CategorySelection", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! CategorySelectionViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        dispatchOnGlobal {
            let keywords = self.checkMatchedKeyword()
            NSThread.sleepForTimeInterval(1.2)
            dispatchOnMain {
                self.setupTableViewFromKeywords(keywords)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //scheme-----------------------
    private func checkMatchedKeyword() -> [String] {
        let infos = self.loadSchemesFromFile()
        let app = UIApplication.sharedApplication()
        return infos.filter {
            $0.hasApp()
        }.map {
            $0.keyword
        }
    }
    private func loadSchemesFromFile() -> [CategoryInfo] {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("url_schemes", ofType: "json")!
        let data = FileUtil.readFileFromPath(path)
        var error : NSError? = nil
        let json = JSON(data : data!)
        let array = json.array!
        
        return array.map(CategoryInfo.parse)
    }
    //
    private func setupTableViewFromKeywords(keywords : [String]) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.loadingView.alpha = 0
        })
        self.keywords = keywords
        self.selections = [Bool]()
        for i in 0..<keywords.count {
            self.selections.append(true)
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: UI event
    
    @IBAction func didClickDecideButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        let index = indexPath.row
        
        let sw = cell.viewWithTag(1) as! UISwitch
        let label = cell.viewWithTag(2) as! UILabel
        
        let act = sw.targetForAction("didSwitchChanged:", withSender: self)
        if act == nil {
            sw.addTarget(self, action: "didSwitchChanged:", forControlEvents: .ValueChanged)
        }
        cell.tag = index
        sw.selected = self.selections[index]
        label.text = self.keywords[index]
        
        return cell
    }
    func didSwitchChanged(sender : AnyObject?) {
        if let sw = sender as? UIView {
            let parent = sw.superview!
            let tag = parent.tag
            self.selections[tag] = !self.selections[tag];
        }
    }
}

class CategoryInfo {
    let keyword : String
    let schemes : [String]
    
    init(keyword : String, schemes : [String]) {
        self.keyword = keyword
        self.schemes = schemes
    }
    
    func hasApp() -> Bool {
        return true
//        let app = UIApplication.sharedApplication()
//        return self.schemes.reduce(false) {(value, scheme) -> Bool in
//            return value || app.canOpenURL(NSURL(string: scheme)!)
//        }
    }
    
    class func parse(json : JSON) -> CategoryInfo {
        let keyword = json["keyword"].stringValue
        let arr = json["schemes"].array!
        let schemes = arr.map {$0.stringValue}
        return CategoryInfo(keyword: keyword, schemes : [])
        
    }
}
