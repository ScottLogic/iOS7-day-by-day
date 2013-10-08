//
//  SCSecondViewController.h
//  ImageFilter
//
//  Created by Sam Davies on 08/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCQRGeneratorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UITextField *stringTextField;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;

- (IBAction)handleGenerateButtonPressed:(id)sender;

@end
