//
//  SCEstimatingTableViewDelegate.h
//  VariTable
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCNonEstimatingTableViewDelegate.h"

@interface SCEstimatingTableViewDelegate : SCNonEstimatingTableViewDelegate

- (instancetype)initWithHeightBlock:(CGFloat (^)(NSUInteger index))heightBlock
                    estimationBlock:(CGFloat (^)(NSUInteger index))estimationBlock;

@end
