//
//  SCTrafficStatus.h
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCTrafficStatus : NSObject

+ (instancetype)randomStatus;

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *status;

@end
