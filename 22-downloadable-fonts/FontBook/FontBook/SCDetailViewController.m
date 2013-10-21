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
