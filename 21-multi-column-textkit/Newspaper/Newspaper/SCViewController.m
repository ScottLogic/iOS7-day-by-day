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

@interface SCViewController () <NSLayoutManagerDelegate> {
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    NSMutableArray *_textContainers;
    NSMutableArray *_textViews;
    CGFloat _currentXOffset;
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
    _layoutManager.delegate = self;
    [_textStorage addLayoutManager:_layoutManager];
    
    _textContainers = [NSMutableArray new];
    _textViews = [NSMutableArray new];
    _currentXOffset = 0.0;
    
    
    // Prepare the first container
    [self createNewTextContainer];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)createNewTextContainer
{
    CGSize columnSize = CGSizeMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.view.bounds));
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:columnSize];
    [_layoutManager addTextContainer:textContainer];
    [_textContainers addObject:textContainer];
    
    // And a text view to render it
    CGRect textViewFrame = CGRectMake(_currentXOffset, 0, columnSize.width, columnSize.height);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:textContainer];
    textView.scrollEnabled = NO;
    [self.scrollView addSubview:textView];
    
    // And update some scrollview settings
    _currentXOffset += columnSize.width;
    CGSize contentSize = CGSizeMake(_currentXOffset, CGRectGetHeight(self.scrollView.bounds));
    self.scrollView.contentSize = contentSize;
}


#pragma mark - NSLayoutManagerDelegate Methods
- (void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag
{
    NSLog(@"New column");
    if (!layoutFinishedFlag) {
        // We need to add some more containers
        [self createNewTextContainer];
    }
}

@end
