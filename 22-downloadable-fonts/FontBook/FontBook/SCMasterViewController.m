//
//  SCMasterViewController.m
//  FontBook
//
//  Created by Sam Davies on 18/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCMasterViewController.h"
#import "SCDetailViewController.h"

@import CoreText;

@interface SCMasterViewController () {
    NSArray *_fontList;
}
@end

@implementation SCMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self requestDownloadableFontList];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fontList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    UIFontDescriptor *font = (UIFontDescriptor *)_fontList[indexPath.row];
    cell.textLabel.text = [font objectForKey:UIFontDescriptorNameAttribute];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIFontDescriptor *descriptor = _fontList[indexPath.row];
        [segue.destinationViewController setFontDescriptor:descriptor];
    }
}


#pragma mark - Font-loading utility methods
- (void)requestDownloadableFontList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *descriptorOptions = @{(id)kCTFontDownloadableAttribute : @YES};
        CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)descriptorOptions);
        CFArrayRef fontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(descriptor, NULL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fontListDownloadComplete:(NSArray *)CFBridgingRelease(fontDescriptors)];
        });
        
        // Need to release the font descriptor
        CFRelease(descriptor);
    });
    
}

- (void)fontListDownloadComplete:(NSArray *)fontList
{
    _fontList = fontList;
    [self.tableView reloadData];
}

@end
