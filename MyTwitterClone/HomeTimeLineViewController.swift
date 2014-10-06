//
//  HomeTimeLineViewController.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/6/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class HomeTimeLineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var TableView: UITableView!
    var tweets : [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
            var error : NSError?
            let jsonData = NSData(contentsOfFile: path)
            
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Step 1: dequeue the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        // Step 2 figure out which model object youre going to use to configure the cell
        // This is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        cell.textLabel?.text = tweet?.text
        // Step 3, return the cell
        return cell
        
    }
    

}
