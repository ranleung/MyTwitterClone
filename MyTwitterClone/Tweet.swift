//
//  Tweet.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/6/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation

class Tweet {
    var text : String
    
    init(tweetInfo: NSDictionary) {
        self.text = tweetInfo["text"] as String
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
            tweets.sort{$1.text > $0.text}
            return tweets
        }
        return nil
    }
}




