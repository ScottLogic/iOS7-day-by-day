//
//  SCViewController.m
//  TrafficStatus
//
//  Created by Sam Davies on 09/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"
#import "SCTrafficStatusTableCell.h"
#import "SCTrafficStatus.h"

@interface SCViewController () {
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) NSMutableArray *trafficStatusUpdates;

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    if(self.trafficStatusUpdates.count == 0) {
        for(int i=0; i<4; i++) {
            [self.trafficStatusUpdates insertObject:[SCTrafficStatus randomStatus] atIndex:0];
        }
    }
}


- (NSMutableArray *)trafficStatusUpdates
{
    if(!_trafficStatusUpdates) {
        _trafficStatusUpdates = [NSMutableArray array];
    }
    return _trafficStatusUpdates;
}

- (void)refreshStatus:(id)sender
{
    [self.trafficStatusUpdates insertObject:[SCTrafficStatus randomStatus] atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [refreshControl endRefreshing];
}

#pragma mark - Datasource/delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trafficStatusUpdates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCTrafficStatusTableCell *cell = (SCTrafficStatusTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TrafficStatusTableCell" forIndexPath:indexPath];
    
    SCTrafficStatus *status = (SCTrafficStatus *)(self.trafficStatusUpdates[indexPath.row]);
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSString *dfs = [NSDateFormatter dateFormatFromTemplate:@"MMM d, HH:mm:ss" options:0 locale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:dfs];
    }
    cell.updatedLabel.text = [dateFormatter stringFromDate:status.date];
    cell.colorBlock.backgroundColor = status.color;
    cell.statusLabel.text = status.status;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.trafficStatusUpdates removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
