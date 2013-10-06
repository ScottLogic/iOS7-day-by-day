//
//  SCStepsViewController.m
//  RouteMaster
//
//  Created by Sam Davies on 06/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCStepsViewController.h"
#import "SCIndividualStepViewController.h"

@interface SCStepsViewController ()

@end

@implementation SCStepsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"Route Steps";
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
    return [self.route.steps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Pull out the correct step
    MKRouteStep *step = self.route.steps[indexPath.row];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%02d) %0.1fkm", indexPath.row, step.distance / 1000.0];
    cell.detailTextLabel.text = step.notice;
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue destinationViewController] isKindOfClass:[SCIndividualStepViewController class]]) {
        SCIndividualStepViewController *vc = (SCIndividualStepViewController *)[segue destinationViewController];
        NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
        
        // If we have a selected row then set the step appropriately
        if(selectedRow) {
            vc.routeStep = self.route.steps[selectedRow.row];
            vc.stepIndex = selectedRow.row;
        }
    }
}

@end
