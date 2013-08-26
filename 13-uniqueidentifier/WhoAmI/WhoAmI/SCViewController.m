//
//  SCViewController.m
//  WhoAmI
//
//  Created by Sam Davies on 26/08/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"
@import AdSupport;

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Vendor IDs";
            break;
            
        case 1:
            return @"Advertising IDs";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = @"identifierForVendor";
        cell.detailTextLabel.text = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"advertisingIdentifier";
                cell.detailTextLabel.text = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
                break;
                
            case 1:
                cell.textLabel.text = @"isAdvertisingEnabled";
                cell.detailTextLabel.text = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ? @"YES" : @"NO";
                
            default:
                break;
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
}



@end
