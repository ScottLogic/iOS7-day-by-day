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
#import "SCAppDelegate.h"

@interface SCViewController () <NSURLSessionDownloadDelegate> {
    NSURLSession *inProcessSession;
    NSURLSessionDownloadTask *cancellableTask;
    NSData *partialDownload;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.progressIndicator.hidden = YES;
    self.progressIndicator.progress = 0;
    
    // Make sure that we've attached to the background session
    self.backgroundSession.sessionDescription = @"Background session";
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
        
        NSString *url = @"http://viewallpapers.com/wp-content/uploads/2013/04/Green-Forest-Nature-Landscape-Pictures-Wallpapers-1080x675.jpg";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        cancellableTask = [inProcessSession downloadTaskWithRequest:request];
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
        // Need to start the download
        [cancellableTask resume];
    }
}

- (IBAction)cancelCancellable:(id)sender {
    if(cancellableTask) {
        [cancellableTask cancel];
        cancellableTask = nil;
    } else if(self.resumableTask) {
        [self.resumableTask cancelByProducingResumeData:^(NSData *resumeData) {
            partialDownload = resumeData;
            self.resumableTask = nil;
        }];
    } else if(self.backgroundTask) {
        [self.backgroundTask cancel];
        self.backgroundTask = nil;
    }
}

- (IBAction)startResumable:(id)sender {
    if(!self.resumableTask) {
        if(!inProcessSession) {
            // Create a 'private browsing' ses
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
            inProcessSession.sessionDescription = @"in-process NSURLSession";
        }
        
        if(partialDownload) {
            self.resumableTask = [inProcessSession downloadTaskWithResumeData:partialDownload];
        } else {
            NSString *url = @"http://hdnaturepictures.com/wp-content/uploads/2013/06/Mountains-View-Landscape.jpg";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            self.resumableTask = [inProcessSession downloadTaskWithRequest:request];
        }
        
        [self setDownloadButtonsAsEnabled:NO];
        self.imageView.hidden = YES;
        // Start the download task
        [self.resumableTask resume];
    }
}

- (IBAction)startBackground:(id)sender {
    NSString *url = @"http://www.hdwallpaperstop.com/wp-content/uploads/2013/05/Beautiful-Landscape-Pictures-of-nature.jpg";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    [self setDownloadButtonsAsEnabled:NO];
    self.imageView.hidden = YES;
    // Start the download
    [self.backgroundTask resume];
}

#pragma mark - Utility methods
- (void)setDownloadButtonsAsEnabled:(BOOL)enabled
{
    for(UIBarButtonItem *btn in self.startButtons) {
        btn.enabled = enabled;
    }
}

- (NSURLSession *)backgroundSession
{
    static NSURLSession *backgroundSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.shinobicontrols.BackgroundDownload.BackgroundSession"];
        backgroundSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    });
    return backgroundSession;
}

#pragma mark - NSURLSessionDownloadDelegate methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressIndicator.hidden = NO;
        self.progressIndicator.progress = currentProgress;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Leave this for now
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
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
    
    if(downloadTask == cancellableTask) {
        cancellableTask = nil;
    } else if (downloadTask == self.resumableTask) {
        self.resumableTask = nil;
        partialDownload = nil;
    } else if (session == self.backgroundSession) {
        self.backgroundTask = nil;
        // Get hold of the app delegate
        SCAppDelegate *appDelegate = (SCAppDelegate *)[[UIApplication sharedApplication] delegate];
        if(appDelegate.backgroundURLSessionCompletionHandler) {
            // Need to copy the completion handler
            void (^handler)() = appDelegate.backgroundURLSessionCompletionHandler;
            appDelegate.backgroundURLSessionCompletionHandler = nil;
            handler();
        }
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
