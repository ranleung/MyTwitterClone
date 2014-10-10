//
//  UserTimeLineControllerViewController.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/9/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class UserTimeLineControllerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView: UITableView!
    var tweet: Tweet!
    var tweets: [Tweet]?
    var networkController : NetworkController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Need to get the user's timeline now.
        self.networkController.fetchUserTimeLine(self.tweet, completionHandler: { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.tweets != nil {
            return self.tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        
        let tweet = self.tweets?[indexPath.row]
        
        cell.textView.text = tweet?.text
        cell.screenName.text = "@\(tweet!.screenName)"
        cell.username.text = tweet?.username

        //Making call for Image
        self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
            let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
            cellForImage?.profilePic.image = image
        })
        
        return cell
    }
    
}
