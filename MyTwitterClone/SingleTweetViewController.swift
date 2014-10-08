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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelagate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelagate.networkController
        
        textView.text = self.tweet.text
        userName.text = self.tweet.username
        screenName.text = "@\(self.tweet.screenName)"
        let imageData = self.networkController.fetchProfilePic(tweet!.urlImage)
        profilePic.image = UIImage(data: imageData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
