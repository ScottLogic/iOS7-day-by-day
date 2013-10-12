//
//  SCViewController.h
//  HotOrCold
//
//  Created by Sam Davies on 12/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

- (IBAction)handleHidingButtonPressed:(id)sender;
- (IBAction)handleStopButtonPressed:(id)sender;
- (IBAction)handleSeekingButtonPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *signalStrengthLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *goButtons;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@end
