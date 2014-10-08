//
//  Tweet.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/6/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation

class Tweet {
    var text: String
    var username: String
    var screenName: String
    var urlImage: String

    
    init(tweetInfo: NSDictionary) {
        self.text = tweetInfo["text"] as String
        let userInfo = tweetInfo["user"] as NSDictionary
        //For username
        self.username = userInfo["name"] as String
        //For screenname
        self.screenName = userInfo["screen_name"] as String
        //For image
        self.urlImage = userInfo["profile_image_url"] as String
    }
    
    
    // Method
    class func parseJSONDataIntoTweets(rawJSONData: NSData) -> [Tweet]? {
        var error: NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: nil) as? NSArray{
            
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray {
                if let tweetDictionary = JSONDictionary as? NSDictionary {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            //Sorting with Closures
            //tweets.sort{$1.text > $0.text}
            return tweets
        }
        return nil
    }
}




