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
    @IBOutlet var userName: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var screenName: UILabel!
    
    //For pull refresh
    var refreshControl: UIRefreshControl!
    
    //For infinite scroll refresh
    var refresh_scroll: UIScrollView!
    
    var tweet: Tweet!
    var tweets: [Tweet]?
    var networkController : NetworkController!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Using Nib instead of segeue
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        userName.text = self.tweet.username
        screenName.text = "@\(self.tweet.screenName)"
        
        //Making network call for images
        self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
            self.profilePic.image = image
            self.profilePic.layer.cornerRadius = 50
            self.profilePic.layer.masksToBounds = true
        })
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension

        //Need to get the user's timeline now.
        self.networkController.fetchUserTimeLine(self.tweet, sinceId: nil, maxId: nil, completionHandler: { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })
        
        // This is for the delegation with nib
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //For the pull refresh reload
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refresh_pull:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
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
            cellForImage?.profilePic.layer.cornerRadius = 10
            cellForImage?.profilePic.layer.masksToBounds = true
        })
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("SingleTweet_VC") as SingleTweetViewController
        let indexPath = self.tableView.indexPathForSelectedRow()!
        let selectedTweet = self.tweets?[indexPath.row]
        newVC.tweet = selectedTweet
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //For pull refresh
    func refresh_pull(sender: AnyObject) {
        println("REFRESHING")
        let tweet = self.tweets?[0]
        self.networkController.fetchUserTimeLine(self.tweet, sinceId: tweet!.id, maxId: nil, completionHandler: { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                //When something wrong happens, should alert that something went wrong.
                println(errorDescription)
            } else {
                self.tweets = tweets! + self.tweets!
                self.tableView.reloadData()
            }
        })
        //To end the refresh
        self.refreshControl.endRefreshing()
    }
    
    //For endless scrolling
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (tweets!.count - 1) {
            println("Now Endless Scrolling")
            let lastTweet = self.tweets?.last
            self.networkController.fetchUserTimeLine(self.tweet, sinceId: nil, maxId: lastTweet!.id, completionHandler: { (errorDescription, tweets) -> (Void) in
                if errorDescription != nil {
                    println(errorDescription)
                } else {
                    var newTweets = tweets!
                    //Need to remove the first tweet to get rid of repeat
                    let removeRepeatedFirstTweet = newTweets.removeAtIndex(0)
                    self.tweets? = self.tweets! + newTweets
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    
    
    
    
    
}
