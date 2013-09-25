//
//  SCSampleCustomControl.m
//  ColorChanger
//
//  Created by Sam Davies on 25/09/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCSampleCustomControl.h"

@implementation SCSampleCustomControl {
    UIView *_tintColorBlock;
    UILabel *_greyLabel;
    UILabel *_tintColorLabel;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self prepareSubviews];
    }
    return self;
}

- (void)prepareSubviews
{
    _tintColorBlock = [[UIView alloc] init];
    _tintColorBlock.backgroundColor = self.tintColor;
    [self addSubview:_tintColorBlock];
    
    _greyLabel = [[UILabel alloc] init];
    _greyLabel.text = @"Grey label";
    _greyLabel.textColor = [UIColor grayColor];
    [_greyLabel sizeToFit];
    [self addSubview:_greyLabel];
    
    _tintColorLabel = [[UILabel alloc] init];
    _tintColorLabel.text = @"Tint color label";
    _tintColorLabel.textColor = self.tintColor;
    [_tintColorLabel sizeToFit];
    [self addSubview:_tintColorLabel];
}

- (void)layoutSubviews
{
    _tintColorBlock.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 3, CGRectGetHeight(self.bounds));
    
    CGRect frame = _greyLabel.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) / 3 + 10;
    frame.origin.y = 0;
    _greyLabel.frame = frame;
    
    frame = _tintColorLabel.frame;
    frame.origin.x = CGRectGetWidth(self.bounds) / 3 + 10;
    frame.origin.y = CGRectGetHeight(self.bounds) / 2;
    _tintColorLabel.frame = frame;
}

- (void)tintColorDidChange
{
    _tintColorLabel.textColor = self.tintColor;
    _tintColorBlock.backgroundColor = self.tintColor;
}



@end
