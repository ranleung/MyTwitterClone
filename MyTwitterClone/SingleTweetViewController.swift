//
//  SingleTweetViewController.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/8/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController {
    
    var tweet: Tweet!
    var networkController: NetworkController!
    
    
    @IBOutlet var textView: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var screenName: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var retweet: UILabel!
    @IBOutlet var favorited: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        self.networkController.fetchSingleTweet(tweet, completionHandler: { (errorDescription, tweet) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.tweet = tweet
                self.favorited.text = "Favorites: \(self.tweet.favorited!.description)"
            }
        })
        
        
        textView.text = self.tweet.text
        userName.text = self.tweet.username
        screenName.text = "@\(self.tweet.screenName)"
        let imageData = self.networkController.fetchProfilePic(self.tweet.urlImage)
        profilePic.image = UIImage(data: imageData)
        var retweetInt = self.tweet.retweet
        var retweetStr = String(retweetInt)
        retweet.text = "Retweets: \(retweetStr)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}