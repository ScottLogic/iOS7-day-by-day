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


#import "SCRotatingViews.h"

@implementation SCRotatingViews

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self generateRotations];
    }
    return self;
}

- (void)generateRotations
{
    for (CGFloat angle = 0; angle < 2 * M_PI; angle += M_PI / 20.0) {
        UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
        newView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        newView.layer.borderColor = [UIColor grayColor].CGColor;
        newView.layer.borderWidth = 1;
        newView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.4];
        newView.transform = CGAffineTransformMakeRotation(angle);
        newView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:newView];
    }
}

- (void)recolorSubviews:(UIColor *)newColor
{
    for (UIView *subview in self.subviews) {
        subview.backgroundColor = newColor;
    }
}

@end
