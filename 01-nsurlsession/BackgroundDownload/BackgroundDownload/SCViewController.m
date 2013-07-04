//
//  SCViewController.m
//  BackgroundDownload
//
//  Created by Sam Davies on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController () {
    NSURLSession *urlSession;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)startDownload:(id)sender {
    if(!urlSession) {
        // Create a 'private browsing' ses
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        urlSession = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lorempixel.com/1920/1920/sports"]];
    [urlSession downloadTaskWithRequest:request completionHandler:^(NSURL *targetPath, NSURLResponse *response, NSError *error) {
        <#code#>
    }];
}
@end
