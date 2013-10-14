//
//  SCViewController.m
//  VariTable
//
//  Created by Sam Davies on 13/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
#import "SCEstimatingTableViewDelegate.h"
#import "SCNonEstimatingTableViewDelegate.h"

@interface SCViewController () {
    id<UITableViewDelegate> _delegate;
    NSDate *_loadStartTime;
}

@end

@implementation SCViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loadStartTime = [NSDate date];
    
    if(self.enableEstimation) {
        _delegate = [[SCEstimatingTableViewDelegate alloc] initWithHeightBlock:^CGFloat(NSUInteger index) {
            return [self heightForRowAtIndex:index];
        } estimationBlock:^CGFloat(NSUInteger index) {
            return 40.0;
        }];
    } else {
        _delegate = [[SCNonEstimatingTableViewDelegate alloc] initWithHeightBlock:^CGFloat(NSUInteger index) {
            return [self heightForRowAtIndex:index];
        }];
    }
    self.tableView.delegate = _delegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSDate *finishLoadTime = [NSDate date];
    NSTimeInterval loadDuration = [finishLoadTime timeIntervalSinceDate:_loadStartTime];
    NSLog(@"Total Load Time: %0.2f", loadDuration);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %03d", indexPath.row];
    CGFloat height = [self heightForRowAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Height %0.2f", height];
    return cell;
}

#pragma mark - Utility methods
- (CGFloat)heightForRowAtIndex:(NSUInteger)index
{
    CGFloat result;
    for (NSInteger i=0; i < 1e5; i++) {
        result = sqrt((double)i);
    }
    result = (index % 3 + 1) * 20.0;
    return result;
}

@end
