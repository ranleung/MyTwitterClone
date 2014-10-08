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

class HomeTimeLineViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var twitterAccount : ACAccount?
    //To connect with the network Controller which is now a singleton.
    //Look into the AppDelagate
    var networkController: NetworkController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //From AppDelagate, using it now.
        //Down casting so we now know its from AppDelagate 
        //The AppDelagate is from the sharedAppliction()
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        //Important!
        //Now need to call on the newtwork controller
        self.networkController.fetchHomeTimeLine { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil {
                //When something wrong happens, should alert that something went wrong.
                println(errorDescription)
            } else {
                self.tweets = tweets
                self.tableView.reloadData()
            }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        // Step 2 figure out which model object youre going to use to configure the cell
        // This is where we would grab a reference to the correct tweet and use it to configure the cell
        let tweet = self.tweets?[indexPath.row]
        
        //For Text
        cell.textView.text = tweet?.text
        
        //For Username
        cell.username.text = tweet?.username
        
        //For Image, Using func from NetworkController
        let imageData = self.networkController.fetchProfilePic(tweet!.urlImage)
        //let urlData = NSURL.URLWithString(tweet!.urlImage)
        //Now making the network call
        //let imageData = NSData(contentsOfURL: urlData)
        cell.profilePic.image = UIImage(data: imageData, scale: UIScreen.mainScreen().scale)
        
        
        // Step 3, return the cell
        return cell
    }
    

}
