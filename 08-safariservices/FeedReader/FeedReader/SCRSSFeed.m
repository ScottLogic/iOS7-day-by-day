//
//  SCRSSFeed.m
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCRSSFeed.h"
#import "SCRSSEntry.h"

@implementation SCRSSFeed

+ (void)feedItemsForURL:(NSURL *)url callback:(RSSFeedCallback)callback
{
    static NSURLSession *session = nil;
    // Create the URLSession
    if(!session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        session = [NSURLSession sessionWithConfiguration:config];
    }
    
    // Perform the fetch
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *items = [NSMutableArray array];
        if(error) {
            NSLog(@"There was an error downloading the feed");
        } else {
            // We've got the feed. Let's convert it from JSON
            NSError *parsingError;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if(parsingError) {
                NSLog(@"There was a problem parsing the JSON");
            } else {
                for (NSDictionary *entry in jsonData[@"value"][@"items"]) {
                    // Looping through the individual items
                    NSURL *url = [NSURL URLWithString:entry[@"link"]];
                    SCRSSEntry *rssEntry = [SCRSSEntry cssEntryWithTitle:entry[@"title"]
                                                                     url:url
                                                             description:entry[@"description"]];
                    [items addObject:rssEntry];
                }
            }
        }
        // Now we have the results, let's send them back
        callback([items copy]);
    }];
    // Start the task
    [task resume];
}

@end
