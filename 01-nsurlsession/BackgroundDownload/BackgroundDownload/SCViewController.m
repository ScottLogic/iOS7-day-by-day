//
//  SCViewController.m
//  BackgroundDownload
//
//  Created by Sam Davies on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController () <NSURLSessionDownloadDelegate> {
    NSURLSession *inProcessSession;
    NSURLSessionDownloadTask *cancellableTask;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.progressIndicator.hidden = YES;
    self.progressIndicator.progress = 0;
}

#pragma mark - Button Methods
- (IBAction)startCancellable:(id)sender {
    if (!cancellableTask) {
        if(!inProcessSession) {
            // Create a 'private browsing' ses
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        NSString *url = @"http://viewallpapers.com/wp-content/uploads/2013/04/Green-Forest-Nature-Landscape-Pictures-Wallpapers.jpg";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        cancellableTask = [inProcessSession downloadTaskWithRequest:request];
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
    }
}

- (IBAction)cancelCancellable:(id)sender {
    if(cancellableTask) {
        [cancellableTask cancel];
        cancellableTask = nil;
    }
    
}

- (IBAction)startResumable:(id)sender {
}

- (IBAction)startBackground:(id)sender {
}

#pragma mark - Utility methods
- (void)setDownloadButtonsAsEnabled:(BOOL)enabled
{
    for(UIBarButtonItem *btn in self.startButtons) {
        btn.enabled = enabled;
    }
}

#pragma mark - NSURLSessionDownloadDelegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if(downloadTask == cancellableTask) {
        double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressIndicator.hidden = NO;
            self.progressIndicator.progress = currentProgress;
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Leave this for now
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if(downloadTask == cancellableTask) {
        // We've successfully finished the download. Let's save the file
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsDirectory = URLs[0];
        
        NSURL *destinationPath = [documentsDirectory URLByAppendingPathComponent:[location lastPathComponent]];
        NSError *error;
        
        // Make sure we overwrite anything that's already there
        [fileManager removeItemAtURL:destinationPath error:NULL];
        BOOL success = [fileManager copyItemAtURL:location toURL:destinationPath error:&error];
        
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithContentsOfFile:[destinationPath path]];
                self.imageView.image = image;
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.hidden = NO;
            });
        }
        else
        {
            NSLog(@"Couldn't copy the downloaded file");
        }
        
        cancellableTask = nil;
    }

}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.hidden = YES;
        [self setDownloadButtonsAsEnabled:YES];
    });
}

@end
