//
//  SCViewController.h
//  GreetingSpeaker
//
//  Created by Sam Davies on 12/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIPickerView *languagePicker;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
- (IBAction)greetingButtonPressed:(id)sender;

@end
