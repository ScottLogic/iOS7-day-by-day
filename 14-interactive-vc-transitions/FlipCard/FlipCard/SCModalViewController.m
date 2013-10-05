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

#import "SCModalViewController.h"

@implementation SCModalViewController

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    // Reset which view controller should be the receipient of the
    // interactor's transition
    self.interactor.presentingVC = self;
}

- (IBAction)handleDismissPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)proceedToNextViewController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
