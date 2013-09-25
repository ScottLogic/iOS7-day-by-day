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
