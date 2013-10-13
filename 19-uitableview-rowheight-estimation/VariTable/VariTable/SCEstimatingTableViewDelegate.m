//
//  SCEstimatingTableViewDelegate.m
//  VariTable
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCEstimatingTableViewDelegate.h"

@implementation SCEstimatingTableViewDelegate {
    CGFloat (^_estimationBlock)(NSUInteger index);
}

- (instancetype)initWithHeightBlock:(CGFloat (^)(NSUInteger index))heightBlock
                    estimationBlock:(CGFloat (^)(NSUInteger index))estimationBlock
{
    self = [super initWithHeightBlock:heightBlock];
    if(self) {
        _estimationBlock = [estimationBlock copy];
    }
    return self;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Estimating height (row %d)", indexPath.row);
    return _estimationBlock(indexPath.row);
}

@end
