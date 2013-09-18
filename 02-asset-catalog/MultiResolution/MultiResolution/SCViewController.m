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


#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGFloat yPosition = 100;
    for(UIImage *image in [self images]) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:image];
        iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, yPosition);
        yPosition += 100;
        [self.view addSubview:iv];
    }
    // Add the sliced images
    [self createButtonImages];
}

- (void)createButtonImages
{
    UIImage *btnImage = [UIImage imageNamed:@"ButtonSlice"];
    
    // Let's make 2
    UIImageView *iv = [[UIImageView alloc] initWithImage:btnImage];
    iv.bounds = CGRectMake(0, 0, 150, CGRectGetHeight(iv.bounds));
    iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 300);
    [self.view addSubview:iv];
    
    // And a stretched version
    iv = [[UIImageView alloc] initWithImage:btnImage];
    iv.bounds = CGRectMake(0, 0, 300, CGRectGetHeight(iv.bounds));
    iv.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, 350);
    [self.view addSubview:iv];
}

- (NSArray *)images
{
    return @[
             [UIImage imageNamed:@"USA"],
             [UIImage imageNamed:@"Australia"]
             ];
}

@end
