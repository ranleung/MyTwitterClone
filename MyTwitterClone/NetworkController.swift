//
//  NetworkController.swift
//  MyTwitterClone
//
//  Created by Randall Leung on 10/8/14.
//  Copyright (c) 2014 Randall. All rights reserved.
//

import Foundation
import Accounts
import Social


class NetworkController {
    
    var twitterAccount: ACAccount?
    
    init() {
        
    }
    
    //Fetch is to download, fetching to the network now
    func fetchHomeTimeLine( completionHandler: (errorDescription: String?, tweets: [Tweet]?)-> (Void)) {
        
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
                        let tweets = Tweet.parseJSONDataIntoTweets(data)
                        println(tweets?.count)
                        //Need to return back to main thread through.  Now getting back on the main quene.
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            //self.tableView.reloadData()
                            
                            //Instead, now we call on the compeletion handler
                            completionHandler(errorDescription: nil, tweets: tweets)
                        })
                        //Now we are back on the main queue, aka thread
                        
                        
                    case 400...499:
                        println("This is the clients fault")
                        println(httpResponse.description)
                        completionHandler(errorDescription: "This is the clients fault", tweets: nil)
                    case 500...599:
                        println("This is the servers fault")
                        completionHandler(errorDescription: "This is the servers fault", tweets: nil)
                    default:
                        println("Something bad happened")
                    }
                })
                
            }
        }

        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}