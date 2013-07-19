//
//  SCRSSFeed.h
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RSSFeedCallback)(NSArray* feedItems);

@interface SCRSSFeed : NSObject

/* Although this class is called an RSS feed, it actually requires a JSON version
 of an RSS feed. This is because this is a demo project and this is simpler than
 parsing an RSS feed. We use yahoo pipes to translate a RSS feed into JSON.
 */

+ (void)feedItemsForURL:(NSURL *)url callback:(RSSFeedCallback)callback;

@end
