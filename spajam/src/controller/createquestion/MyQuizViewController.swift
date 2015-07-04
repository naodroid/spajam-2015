//
//  CategorySelectionViewController.swift
//  spajam
//
//  Created by 坂本尚嗣 on 2015/07/04.
//  Copyright (c) 2015年 坂本尚嗣. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyQuizViewController: UIViewController,
                         UITableViewDataSource, UITableViewDelegate {

    ///IB
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var categories = [CategoryInfo]()
    
    
    
    ///
    class func createVC() -> MyQuizViewController {
        let sb = UIStoryboard(name: "MyQuizViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! MyQuizViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        dispatchOnGlobal {
            let categories = self.checkMatchedCategories()
            NSThread.sleepForTimeInterval(1.2)
            dispatchOnMain {
                self.setupTableViewFromCategories(categories)
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MyQuizUpdatedEvent.register(self) {(event : MyQuizUpdatedEvent) in
            self.tableView.reloadData()
        }
    }
    override func viewWillDisappear(animated: Bool) {
        MyQuizUpdatedEvent.unregister(self)
        super.viewWillDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //scheme-----------------------
    private func checkMatchedCategories() -> [CategoryInfo] {
        let infos = self.loadSchemesFromFile()
        let app = UIApplication.sharedApplication()
        return infos.filter {
            $0.hasApp()
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
    private func setupTableViewFromCategories(categories : [CategoryInfo]) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.loadingView.alpha = 0
        })
        self.categories = categories
        
        self.tableView.reloadData()
    }
    
    //MARK: UI event
    
    @IBAction func didClickDecideButton(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MyQuizTableViewCell
        
        let index = indexPath.row
        let category = self.categories[index]
        let quiz = MyQuizList.instance().list[category.name]
        
        cell.updateCell(category: category, hasQuiz: quiz != nil)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let index = indexPath.row
        let category = self.categories[index]
        
        let vc = SetQuizViewController.createVC(self.storyboard!, category: category.name)
        self.addChildViewController(vc)
        vc.didMoveToParentViewController(self)
        self.view.addSubview(vc.view)
        vc.startEnterAnimation()
    }
    
}

class CategoryInfo {
    let name : String
    let imageUrl : String
    let schemes : [String]
    
    init(name : String, imageUrl : String, schemes : [String]) {
        self.name = name
        self.imageUrl = imageUrl
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
        let name = json["name"].stringValue
        let image = json["image"].stringValue
        let arr = json["schemes"].array!
        let schemes = arr.map {$0.stringValue}
        return CategoryInfo(name: name, imageUrl : image, schemes : [])
        
    }
}
