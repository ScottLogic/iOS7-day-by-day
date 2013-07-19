//
//  SCDetailViewController.m
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCDetailViewController.h"
@import SafariServices;

@interface SCDetailViewController ()
- (void)configureView;
@end

@implementation SCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.titleLabel.text = [self.detailItem title];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (IBAction)readLaterButtonPressed:(id)sender {
    if([SSReadingList supportsURL:[self.detailItem url]]) {
        SSReadingList *readingList = [SSReadingList defaultReadingList];
        NSError *error;
        [readingList addReadingListItemWithURL:[self.detailItem url] title:[self.detailItem title] previewText:[self.detailItem description] error:&error];
        if(error) {
            NSLog(@"There was a problem adding to a reading list");
        } else {
            NSLog(@"Successfully added to reading list");
        }
    }
    
}

@end
