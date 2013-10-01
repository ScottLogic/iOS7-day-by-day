//
//  SCRSSEntry.m
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCRSSEntry.h"

@implementation SCRSSEntry

#pragma mark - Class Methods
+ (instancetype)cssEntryWithTitle:(NSString *)title url:(NSURL *)url description:(NSString *)description
{
    return [[self alloc] initWithTitle:title url:url description:description];
}


#pragma mark - Instance methods
- (instancetype)initWithTitle:(NSString *)title url:(NSURL *)url description:(NSString *)description
{
    self = [super init];
    if(self) {
        self.title = title;
        self.url = url;
        self.description = description;
    }
    return self;
}

@end
