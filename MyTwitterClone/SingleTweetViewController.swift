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
                self.favorited.text = self.tweet.favorited!.description
            }
        })
        
        
        textView.text = self.tweet.text
        userName.text = self.tweet.username
        screenName.text = "@\(self.tweet.screenName)"
        
        //Making network call for images
        self.networkController.downloadUserImageForTweet(tweet!, completionHandler: { (image) -> (Void) in
            self.profilePic.image = image
            self.profilePic.layer.cornerRadius = 10
            self.profilePic.layer.masksToBounds = true
        })
        
        var retweetInt = self.tweet.retweet
        var retweetStr = String(retweetInt)
        retweet.text = retweetStr
        
        //This is for the gesture
        var tapRecongizer = UITapGestureRecognizer(target: self, action: "userPressed:")
        self.profilePic.addGestureRecognizer(tapRecongizer)
    }
    
    //When the image button is pressed
    func userPressed(sender : UITapGestureRecognizer) {
        println("user image is pressed")
        
        let newVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_TIMELINE_VC") as UserTimeLineControllerViewController
        newVC.tweet = self.tweet
        self.navigationController?.pushViewController(newVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
