//
//  NSArray+Random.m
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)

- (id)randomElement
{
    NSUInteger randomIndex = arc4random_uniform(self.count);
    return self[randomIndex];
}

@end
