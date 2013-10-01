//
//  SCRSSEntry.h
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRSSEntry : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSString *description;


+ (instancetype)cssEntryWithTitle:(NSString *)title url:(NSURL *)url description:(NSString *)description;

- (instancetype)initWithTitle:(NSString *)title url:(NSURL*)url description:(NSString*)description;

@end
