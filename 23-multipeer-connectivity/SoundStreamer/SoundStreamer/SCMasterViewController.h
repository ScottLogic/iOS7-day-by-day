//
//  SCMasterViewController.h
//  SoundStreamer
//
//  Created by Sam Davies on 20/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMasterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *findPeersButton;
@property (weak, nonatomic) IBOutlet UITextField *peerNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *startStreamingButton;

- (IBAction)handleFindPeersButton:(id)sender;
- (IBAction)handleStartStreamingPressed:(id)sender;

@end
