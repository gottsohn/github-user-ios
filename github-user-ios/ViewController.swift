//
//  ViewController.swift
//  github-user-ios
//
//  Created by Godson Ukpere on 6/25/16.
//  Copyright © 2016 Godson Ukpere. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView:UITableView!
    var repos:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUserRepos()
    }
    
    func getUserRepos() {
        Alamofire.request(.GET, "https://api.github.com/users/gottsohn/repos").responseJSON {
            (response) in
            
            switch response.result {
            case .Success:
                self.repos = JSON(data: response.data!).arrayValue
                self.tableView.reloadData()
            case .Failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repo = repos[indexPath.row]
        if let urlString = repo["clone_url"].string,
            let url = NSURL(string: urlString) {
            
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let repo = repos[indexPath.row]
        
        cell.textLabel?.text = repo["name"].stringValue
        cell.detailTextLabel?.text = repo["language"].stringValue
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}

