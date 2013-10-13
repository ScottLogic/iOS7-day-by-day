//
//  SCNonEstimatingTableViewDelegate.h
//  VariTable
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCNonEstimatingTableViewDelegate : NSObject <UITableViewDelegate>

- (instancetype)initWithHeightBlock:(CGFloat (^)(NSUInteger index))heightBlock;

@end
