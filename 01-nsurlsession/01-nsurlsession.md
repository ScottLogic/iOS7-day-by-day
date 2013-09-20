# iOS7 Day-by-Day: Day 1
## NSURLSession

In the past networking for iOS was performed using `NSURLConnection` which used
the global state to manage cookies and authentication. Therefore it was possible
to have 2 different connections competing with each other for shared settings.
`NSURLSession` sets out to solve this problem and a host of others as well.

The project which accompanies this guide includes the three different download
scenarios discussed forthwith. This post won't describe the entire project - just
the salient parts associated with the new `NSURLSession` API.

### Simple download

`NSURLSession` represents the entire state associated with multiple connections,
which was formerly a shared global state. Session objects are created with a
factory method which takes a configuration object. There are 3 types of possible
sessions:

1. Default, in-process session
2. Ephemeral (in-memory), in-process session
3. Background session

For a simple download we'll just use a default session:

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

Once a configuration object has been created there are properties on it which
control the way it behaves. For example, it's possible to set acceptable levels
of TLS security, whether cookies are allowed and timeouts. Two of the more interesting
properties are `allowsCellularAccess` and `discretionary`. The former specifies
whether a device is permitted to run the networking session when only a cellular
radio is available. Setting a session as discretionary enables the operating
system to schedule the network access to sensible times - i.e. when a WiFi network
is available, and when the device has good power. This is primarily of use for
background sessions, and as such defaults to true for a background session.

Once we have a session configuration object we can create the session itself:

    NSURLSession *inProcessSession;
    inProcessSession = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];

Note here that we're also setting ourselves as a delegate. Delegate methods are
used to notify us of the progress of data transfers and to request information
when challenged for authentication. We'll implement some appropriate methods soon.

Data transfers are encapsulated in tasks - of which there are three types:

1. Data task (`NSURLSessionDataTask`)
2. Upload task (`NSURLSessionUploadTask`)
3. Download task (`NSURLSessionDownloadTask`)

In order to perform a transfer within the session we need to create a task. For
a simple file download:

    NSString *url = @"http://appropriate/url/here";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
    NSURLSessionDownloadTask *cancellableTask = [inProcessSession downloadTaskWithRequest:request];
    [cancellableTask resume];

That's all there is to it - the session will now asynchronously attempt to download
the file at the specified URL.

In order to get hold of the requested file download we need to implement a delegate
method:

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
        }
    }

This method is defined on `NSURLSessionDownloadTaskDelegate`. We get passed the
temporary location of the downloaded file, so in this code we're saving it off
to the documents directory and then (since we have a picture) displaying it
to the user.

The above delegate method only gets called if the download task succeeds. The
following method is on `NSURLSessionDelegate` and gets called after every task
finishes, irrespective of whether it completes successfully:

    - (void)URLSession:(NSURLSession *)session
                  task:(NSURLSessionTask *)task
    didCompleteWithError:(NSError *)error
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressIndicator.hidden = YES;
        });
    }

If the error object is `nil` then the task completed without a problem. Otherwise
it's possible to query it to find out what the problem was. If a partial download
has been completed then the error object contains a reference to an `NSData`
object which can be used to resume the transfer at a later stage.

### Tracking progress

You'll have noticed that we hid a progress indicator as part of the task completion
method at the end of the last section. Updating the progress of this progress
bar couldn't be easier. There is an additional delegate method which is called
zero or more times during in the task's lifetime:

    - (void)URLSession:(NSURLSession *)session
          downloadTask:(NSURLSessionDownloadTask *)downloadTask
          didWriteData:(int64_t)bytesWritten
          BytesWritten:(int64_t)totalBytesWritten
          totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
    {
        double currentProgress = totalBytesWritten / (double)totalBytesExpectedToWrite;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressIndicator.hidden = NO;
            self.progressIndicator.progress = currentProgress;
        });
    }

This is another method which is part of the `NSURLSessionDownloadTaskDelegate`,
and we use it here to estimate the progress and update the progress indicator.


### Canceling a download

Once an `NSURLConnection` had been sent off it was impossible to cancel it. This
is different with an easy ability to cancel the an `NSURLSessionTask`:

    - (IBAction)cancelCancellable:(id)sender {
        if(cancellableTask) {
            [cancellableTask cancel];
            cancellableTask = nil;
        }
    }

It's as easy as that! It's worth noting that once a task has been canceled the
`URLSession:task:didCompleteWithError:` delegate method will be called to enable
you to update the UI appropriately. It's quite possible that after canceling a
task the `URLSession:downloadTask:didWriteData:BytesWritten:totalBytesExpectedToWrite:`
method might be called again, however, the didComplete method will definitely be
last.


### Resumable download

It's also possible to resume a download pretty easily. There is an alternative
cancel method which provides an `NSData` object which can be used to create a
new task to continue the transfer at a later stage. If the server supports
resuming downloads then the data object will include the bytes already downloaded:

    - (IBAction)cancelCancellable:(id)sender {
        if(self.resumableTask) {
            [self.resumableTask cancelByProducingResumeData:^(NSData *resumeData) {
                partialDownload = resumeData;
                self.resumableTask = nil;
            }];
        }
    }

Here we've popped the resume data into an ivar which we can later use to resume
the download.

When creating the download task, rather than supplying a request you can
provide a resume data object:

    if(!self.resumableTask) {       
        if(partialDownload) {
            self.resumableTask = [inProcessSession downloadTaskWithResumeData:partialDownload];
        } else {
            NSString *url = @"http://url/for/image";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            self.resumableTask = [inProcessSession downloadTaskWithRequest:request];
        }
        [self.resumableTask resume];
    }

If we've got a partialDownload object then we create the task using that, otherwise
we create the task as we did before.

The only other thing to remember here is that we need to set `partialDownload = nil;`
when the process ends.


### Background download

The other major feature that `NSURLSession` introduces is the ability to continue
data transfers even when your app isn't running. In order to do this we configure
a session to be a background session:

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

It's important to note that we can only create one session with a given background
token, hence the dispatch once block. The purpose of the token is to allow us
to collect the session once our app is restarted. Creating a background session
starts up a background transfer daemon which will manage the data transfer for
us. This will continue to run even when the app has been suspended or terminated.

Starting a background download task is exactly the same as we did before - all
of the 'background' functionality is managed by the `NSURLSession` we have just
created:

    NSString *url = @"http://url/for/picture";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.backgroundTask = [self.backgroundSession downloadTaskWithRequest:request];
    [self.backgroundTask resume];

Now, even when you press the home button to leave the app, the download will
continue in the background (subject to the configuration options mentioned at
the start).

When the download is completed then iOS will restart your app to let it know -
and to pass it the payload. To do this it calls the following method on your app
delegate:

    - (void)application:(UIApplication *)application
    handleEventsForBackgroundURLSession:(NSString *)identifier
                      completionHandler:(void (^)())completionHandler
    {
        self.backgroundURLSessionCompletionHandler = completionHandler;
    }

Here we get passed a completion handler, which once we've accepted the downloaded
data and updated our UI appropriately, we should call. Here we're saving off the
completion handler (remembering that blocks have to be copied), and letting the
loading of the view controller manage the data handling. When the view controller
is loaded it creates the background session (which sets the delegate) and therefore
the same delegate methods we were using before are called.

    - (void)URLSession:(NSURLSession *)session
          downloadTask:(NSURLSessionDownloadTask *)downloadTask
          didFinishDownloadingToURL:(NSURL *)location
    {
        // Save the file off as before, and set it as an image view
        //...
        
        if (session == self.backgroundSession) {
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

There are a few things to note here:

- We can't compare `downloadTask` to `self.backgroundTask`. This is because we
can't guarantee that `self.backgroundTask` has been populated since this could
be a new launch of the app. Comparing the session is valid though.
- Here we grab hold of the app delegate. There are other ways of passing the
completion handler to the right place.
- Once we've finished saving the file and displaying it we make sure that if we
have a completion handler, we remove it, and then invoke it. This tells the
operating system that we've finished handling the new download.


### Summary

`NSURLSession` provides a lot of new invaluable features for dealing with
networking in iOS (and OSX 10.9) and replaces the old way of doing things. It's
worth getting to grips with it and using it for all apps that can be targetted
at the new operating systems.

