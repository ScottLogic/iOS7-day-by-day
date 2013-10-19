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

#import "SCFontFamilyViewController.h"
#import "SCFontViewController.h"

@import CoreText;

@interface SCFontFamilyViewController () {
    NSDictionary *_fontList;
}
@end

@implementation SCFontFamilyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"Families";
    
    [self requestDownloadableFontList];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_fontList allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    NSString *fontFamilyName = [_fontList allKeys][indexPath.row];
    cell.textLabel.text = fontFamilyName;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowFamily"]) {
        SCFontViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *fontFamilyName = [_fontList allKeys][indexPath.row];
        NSArray *fontList = _fontList[fontFamilyName];
        vc.fontList = fontList;
        vc.title = fontFamilyName;
    }
}


#pragma mark - Font-loading utility methods
- (void)requestDownloadableFontList
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSDictionary *descriptorOptions = @{(id)kCTFontDownloadableAttribute : @YES};
        CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)descriptorOptions);
        CFArrayRef fontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(descriptor, NULL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fontListDownloadComplete:(NSArray *)CFBridgingRelease(fontDescriptors)];
        });
        
        // Need to release the font descriptor
        CFRelease(descriptor);
    });
    
}

- (void)fontListDownloadComplete:(NSArray *)fontList
{
    // Need to reorganise array into dictionary
    NSMutableDictionary *fontFamilies = [NSMutableDictionary new];
    for(UIFontDescriptor *descriptor in fontList) {
        NSString *fontFamilyName = [descriptor objectForKey:UIFontDescriptorFamilyAttribute];
        NSMutableArray *fontDescriptors = [fontFamilies objectForKey:fontFamilyName];
        if(!fontDescriptors) {
            fontDescriptors = [NSMutableArray new];
            [fontFamilies setObject:fontDescriptors forKey:fontFamilyName];
        }
        
        [fontDescriptors addObject:descriptor];
    }
    
    _fontList = [fontFamilies copy];
    
    [self.tableView reloadData];
}

@end
