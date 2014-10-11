//
//  HomeTimeLineViewController.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/6/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit
//Have access to the accounts
import Accounts
//Social Framework brings in SL Request
import Social

class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    //To connect with the network Controller which is now a singleton.
    //Look into the AppDelagate
    var networkController: NetworkController!
    
    //For pull refresh
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        //Using Nib instead of segeue
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
        
        
        tableView.estimatedRowHeight = 148.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //From AppDelagate, using it now.
        //Down casting so we now know its from AppDelagate 
        //The AppDelagate is from the sharedAppliction()
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        //Important!
        //Now need to call on the newtwork controller
        //self.networkController.fetchHomeTimeLine { (errorDescription, tweets) -> (Void) in
        self.networkController.fetchHomeTimeLine(nil, maxId: nil, completionHandler: { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                //When something wrong happens, should alert that something went wrong.
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
        
        //For the scroll reload
        //refresh_scroll(self.tableView)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        // Step 2 figure out which model object youre going to use to configure the cell
        // This is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        
        //For Text
        cell.textView.text = tweet?.text
        
        //For ScreenName
        cell.screenName.text = "@\(tweet!.screenName)"
        
        //For Username
        cell.username.text = tweet?.username
        
        
        //For Image, Using func from NetworkController
        self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
            let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
            cellForImage?.profilePic.image = image
            cellForImage?.profilePic.layer.cornerRadius = 10
            cellForImage?.profilePic.layer.masksToBounds = true

            
        })
        
        //let urlData = NSURL.URLWithString(tweet!.urlImage)
        //Now making the network call
        //let imageData = NSData(contentsOfURL: urlData)
        //cell.profilePic.image = UIImage(data: imageData)
        
        
        // Step 3, return the cell
        return cell
    }
    
//    For Old segue
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showTweet" {
//            let showTweet = segue.destinationViewController as SingleTweetViewController
//            let indexPath = self.tableView.indexPathForSelectedRow()!
//            let selectedTweet = self.tweets?[indexPath.row]
//            showTweet.tweet = selectedTweet
//        }
//    }
    
    
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
        self.networkController.fetchHomeTimeLine(tweet!.id, maxId: nil, completionHandler: { (errorDescription, tweets) -> (Void) in
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
            let tweet = self.tweets?.last
            self.networkController.fetchHomeTimeLine(nil, maxId: tweet?.id, completionHandler: { (errorDescription, tweets) -> (Void) in
                if errorDescription != nil {
                    println(errorDescription)
                } else {
                    var newTweets = tweets!
                    //Need to remove the first tweet to get rid of repeat
                    let removeRepeatedFirstTweet = newTweets.removeAtIndex(0)
                    self.tweets? += newTweets
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    
    
    

}






