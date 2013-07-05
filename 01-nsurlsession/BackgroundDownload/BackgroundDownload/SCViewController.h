//
//  SCViewController.h
//  BackgroundDownload
//
//  Created by Sam Davies on 04/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController

@property (strong, nonatomic) NSURLSessionDownloadTask *resumableTask;
@property (strong, nonatomic) NSURLSessionDownloadTask *backgroundTask;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressIndicator;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *startButtons;

- (IBAction)startCancellable:(id)sender;
- (IBAction)cancelCancellable:(id)sender;
- (IBAction)startResumable:(id)sender;
- (IBAction)startBackground:(id)sender;



@end
