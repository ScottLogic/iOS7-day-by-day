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

@interface SCViewController () {
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Import the content into a text storage object
    NSURL *contentURL = [[NSBundle mainBundle] URLForResource:@"content" withExtension:@"txt"];
    _textStorage = [[NSTextStorage alloc] initWithFileURL:contentURL
                                                  options:nil
                                       documentAttributes:NULL
                                                    error:NULL];
    
    // Create a layout manager
    _layoutManager = [[NSLayoutManager alloc] init];
    [_textStorage addLayoutManager:_layoutManager];
    
    // Layout the text containers
    [self layoutTextContainers];
    
}

- (void)layoutTextContainers
{
    NSUInteger lastRenderedGlyph = 0;
    CGFloat currentXOffset = 0;
    while (lastRenderedGlyph < _layoutManager.numberOfGlyphs) {
        CGRect textViewFrame = CGRectMake(currentXOffset, 10,
                                          CGRectGetWidth(self.view.bounds) / 2,
                                          CGRectGetHeight(self.view.bounds) - 20);
        CGSize columnSize = CGSizeMake(CGRectGetWidth(textViewFrame) - 20,
                                       CGRectGetHeight(textViewFrame) - 10);
        
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:columnSize];
        [_layoutManager addTextContainer:textContainer];
        
        // And a text view to render it
        UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame
                                                   textContainer:textContainer];
        textView.scrollEnabled = NO;
        [self.scrollView addSubview:textView];
        
        
        // Increase the current offset
        currentXOffset += CGRectGetWidth(textViewFrame);
        
        // And find the index of the glyph we've just rendered
        lastRenderedGlyph = NSMaxRange([_layoutManager glyphRangeForTextContainer:textContainer]);
    }
    
    // Need to update the scrollView size
    CGSize contentSize = CGSizeMake(currentXOffset, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.contentSize = contentSize;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
