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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        //Want account type of Twitter
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted: Bool, error: NSError!) -> Void in
            //If granted, set the Account to the SLRequest
            if granted {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                //Also becomes a background thread here
                twitterRequest.performRequestWithHandler({ (data, httpResponse, error) -> Void in
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("This is good!")
                        //Right here, we are on a background queue (thread).
                        //Never do network calls in the main queue.  Social framework takes care of this automatically.
                        self.tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(self.tweets?.count)
                        //Need to return back to main thread through.  Now getting back on the main quene.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.tableView.reloadData()
                        })
                        //Now we are back on the main queue, aka thread
                        
                        
                    case 400...499:
                        println("This is the clients fault")
                        println(httpResponse.description)
                    case 500...599:
                        println("This is the servers fault")
                    default:
                        println("Something bad happened")
                    }
                })
                
            }
        }
        
        
        
//        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json") {
//            var error : NSError?
//            let jsonData = NSData(contentsOfFile: path)
//            
//            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
//        }
        
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
        cell.textView.text = tweet?.text
        //For Image
        let urlData = NSURL.URLWithString(tweet!.urlImage)
        let imageData = NSData(contentsOfURL: urlData)
        cell.profilePic.image = UIImage(data: imageData)
        // Step 3, return the cell
        return cell
    }
    

}
