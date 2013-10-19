//
//  SCFontViewController.m
//  FontBook
//
//  Created by Sam Davies on 19/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCFontViewController.h"
#import "SCDetailViewController.h"

@interface SCFontViewController ()

@end

@implementation SCFontViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setFontList:(NSArray *)fontList
{
    if(fontList != _fontList) {
        _fontList = fontList;
        [self.tableView reloadData];
    }
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
    return [self.fontList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FontCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UIFontDescriptor *descriptor = self.fontList[indexPath.row];
    cell.textLabel.text = [descriptor objectForKey:UIFontDescriptorNameAttribute];
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIFontDescriptor *descriptor = self.fontList[indexPath.row];
        [segue.destinationViewController setFontDescriptor:descriptor];
    }
}

@end
