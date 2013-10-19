//
//  SCDetailViewController.m
//  FontBook
//
//  Created by Sam Davies on 18/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCDetailViewController.h"
@import CoreText;

@interface SCDetailViewController ()
@end

@implementation SCDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self updateView];
}

- (void)setFontDescriptor:(UIFontDescriptor *)fontDescriptor
{
    if(_fontDescriptor != fontDescriptor) {
        _fontDescriptor = fontDescriptor;
        [self updateView];
    }
}

- (void)updateView
{
    NSString *fontName = [self.fontDescriptor objectForKey:UIFontDescriptorNameAttribute];
    self.title = fontName;
    UIFont *font = [UIFont fontWithName:fontName size:26.f];
    if(font && [font.fontName isEqualToString:fontName]) {
        self.sampleTextLabel.font = font;
        self.downloadButton.enabled = NO;
        self.detailDescriptionLabel.text = @"Font available";
    } else {
        self.sampleTextLabel.font = [UIFont systemFontOfSize:font.pointSize];
        self.downloadButton.enabled = YES;
        self.detailDescriptionLabel.text = @"This font is not yet downloaded";
    }
}

- (IBAction)handleDownloadPressed:(id)sender {
    self.downloadProgressBar.hidden = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler((CFArrayRef)@[_fontDescriptor], NULL, ^bool(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadProgressBar.hidden = YES;
                [self updateView];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadProgressBar.progress = progressValue;
            });
        }
        return (bool)YES;
    });
}

@end
