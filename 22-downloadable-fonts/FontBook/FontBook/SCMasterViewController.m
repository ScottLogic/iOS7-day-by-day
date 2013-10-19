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

#import "SCMasterViewController.h"
#import "SCDetailViewController.h"

@import CoreText;

@interface SCMasterViewController () {
    NSArray *_fontList;
}
@end

@implementation SCMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self requestDownloadableFontList];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fontList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    UIFontDescriptor *font = (UIFontDescriptor *)_fontList[indexPath.row];
    cell.textLabel.text = [font objectForKey:UIFontDescriptorNameAttribute];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UIFontDescriptor *descriptor = _fontList[indexPath.row];
        [segue.destinationViewController setFontDescriptor:descriptor];
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
    _fontList = fontList;
    [self.tableView reloadData];
}

@end
