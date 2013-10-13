//
//  SCNonEstimatingTableViewDelegate.m
//  VariTable
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCNonEstimatingTableViewDelegate.h"

@implementation SCNonEstimatingTableViewDelegate
{
    CGFloat (^_heightBlock)(NSUInteger index);
}

- (instancetype)initWithHeightBlock:(CGFloat (^)(NSUInteger))heightBlock
{
    self = [super init];
    if(self) {
        _heightBlock = [heightBlock copy];
    }
    return self;
}

#pragma mark - UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Height (row %d)", indexPath.row);
    return _heightBlock(indexPath.row);
}

@end
