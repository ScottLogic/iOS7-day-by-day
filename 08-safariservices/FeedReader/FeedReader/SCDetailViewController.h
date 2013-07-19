//
//  SCDetailViewController.h
//  FeedReader
//
//  Created by Sam Davies on 19/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)readLaterButtonPressed:(id)sender;
@end
