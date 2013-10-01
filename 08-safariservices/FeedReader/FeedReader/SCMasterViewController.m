//
//  SCMasterViewController.m
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCMasterViewController.h"

#import "SCDetailViewController.h"
#import "SCRSSFeed.h"
#import "SCRSSEntry.h"

@interface SCMasterViewController () {
    NSArray *_objects;
}
@end

@implementation SCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Get hold of the data
    [SCRSSFeed feedItemsForURL:[NSURL URLWithString:@"http://pipes.yahoo.com/pipes/pipe.run?_id=6c2c9126afe9c1ea2c481a577732bd7b&_render=json"]
                      callback:^(NSArray *feedItems) {
                          _objects = feedItems;
                          [self.tableView reloadData];
                      }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SCRSSEntry *feedEntry = _objects[indexPath.row];
    cell.textLabel.text = feedEntry.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SCRSSEntry *feedItem = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:feedItem];
    }
}

@end
