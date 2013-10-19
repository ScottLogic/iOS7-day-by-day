//
//  SCDetailViewController.h
//  FontBook
//
//  Created by Sam Davies on 18/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sampleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) UIFontDescriptor *fontDescriptor;
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgressBar;

- (IBAction)handleDownloadPressed:(id)sender;

@end
