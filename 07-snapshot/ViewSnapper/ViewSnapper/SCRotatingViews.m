//
//  SCRotatingViews.m
//  ViewSnapper
//
//  Created by Sam Davies on 29/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

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
