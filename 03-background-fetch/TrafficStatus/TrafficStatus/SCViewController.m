/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCViewController.h"
#import "SCTrafficStatusTableCell.h"
#import "SCTrafficStatus.h"

typedef void(^SCTrafficStatusCreationComplete)();

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
        [self createNewStatusUpdatesWithMin:1 max:4 completionBlock:NULL];
    }
}

#pragma mark - API Methods

- (NSMutableArray *)trafficStatusUpdates
{
    if(!_trafficStatusUpdates) {
        _trafficStatusUpdates = [NSMutableArray array];
    }
    return _trafficStatusUpdates;
}

- (NSUInteger)insertStatusObjectsForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSUInteger numberCreated = [self createNewStatusUpdatesWithMin:0 max:3 completionBlock:NULL];
    NSLog(@"Background fetch completed - %d new updates", numberCreated);
    UIBackgroundFetchResult result = UIBackgroundFetchResultNoData;
    if(numberCreated > 0) {
        result = UIBackgroundFetchResultNewData;
    }
    completionHandler(result);
    return numberCreated;
}

- (NSUInteger)createNewStatusUpdatesWithMin:(NSUInteger)min max:(NSUInteger)max completionBlock:(SCTrafficStatusCreationComplete)completionHandler
{
    NSUInteger numberToCreate = arc4random_uniform(max-min) + min;
    NSMutableArray *indexPathsToUpdate = [NSMutableArray array];
    
    for(int i=0; i<numberToCreate; i++) {
        [self.trafficStatusUpdates insertObject:[SCTrafficStatus randomStatus] atIndex:0];
        [indexPathsToUpdate addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView insertRowsAtIndexPaths:indexPathsToUpdate withRowAnimation:UITableViewRowAnimationFade];
    if(completionHandler) {
        completionHandler();
    }
    
    return numberToCreate;
}

#pragma mark - Utility methods

- (void)refreshStatus:(id)sender
{
    [self createNewStatusUpdatesWithMin:0 max:3 completionBlock:^{
        [refreshControl endRefreshing];
    }];
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
