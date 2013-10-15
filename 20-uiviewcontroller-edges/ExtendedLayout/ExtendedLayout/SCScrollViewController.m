/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCScrollViewController.h"

@interface SCScrollViewController ()

@end

@implementation SCScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat boxHeight = 100;
    NSUInteger numberBoxes = 20;
    
    // Set the scroll view size appropriately
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), numberBoxes * (boxHeight));
    
    // Make some content for the scrollview
    for (NSUInteger i = 0; i < numberBoxes; i++) {
        // Just simple views
        UIView *box = [[UIView alloc] initWithFrame:CGRectMake(0, i * boxHeight, CGRectGetWidth(self.scrollView.bounds), boxHeight)];
        if(i % 2) {
            box.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.9];
        } else {
            box.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.9];
        }
        
        // Add a number label
        UILabel *label = [[UILabel alloc] initWithFrame:box.bounds];
        label.text = [NSString stringWithFormat:@"%d", i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:20.f];
        [box addSubview:label];
        [self.scrollView addSubview:box];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
