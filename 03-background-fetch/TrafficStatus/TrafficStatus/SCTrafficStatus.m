//
//  SCTrafficStatus.m
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCTrafficStatus.h"
#import "NSArray+Random.h"

@implementation SCTrafficStatus

+ (instancetype)randomStatus
{
    SCTrafficStatus *status = [[SCTrafficStatus alloc] init];
    
    status.date = [NSDate date];
    status.color = [[self availableColors] randomElement];
    status.status = [[self availableRoads] randomElement];
    
    return status;
}



+ (NSArray *)availableColors
{
    return @[
             [UIColor redColor],
             [UIColor orangeColor],
             [UIColor yellowColor],
             [UIColor greenColor]
             ];
}

+ (NSArray *)availableRoads
{
    return @[
             @"HWY-1",
             @"Route 66",
             @"US-1",
             @"Lincoln Highway",
             @"Blue Ridge Parkway",
             @"HWY-375",
             @"Columbia River Highway",
             @"HI-360",
             @"US-212"
             ];
}

@end
