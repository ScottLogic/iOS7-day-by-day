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
@import AVFoundation;

@interface SCViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureStillImageOutput *_stillImageOutput;
    AVCaptureSession *_session;
    CIDetector *_faceDetector;
    CIContext *_ciContext;
}

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Create a new AVCaptureSession
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPreset640x480];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // Want the normal device
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        // Add the input to the session
        [_session addInput:input];
    } else {
        NSLog(@"error: %@", error);
        return;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [_session addOutput:output];
    // What different things can we register to recognise?
    NSLog(@"%@", [output availableMetadataObjectTypes]);
    // We're only interested in faces
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    // This VC is the delegate. Please call us on the main queue
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Prepare an output for snapshotting
    _stillImageOutput = [AVCaptureStillImageOutput new];
    [_session addOutput:_stillImageOutput];
    _stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    
    // Display on screen
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.bounds = self.view.bounds;
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.layer addSublayer:_previewLayer];
    
    self.imageView.hidden = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.retakeButton.hidden = YES;
    
    // Start the AVSession running
    [_session startRunning];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate methods
- (void)captureOutput:(AVCaptureOutput *)captureOutput
    didOutputMetadataObjects:(NSArray *)metadataObjects
              fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *metadataObject in metadataObjects) {
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeFace]) {
            // Take an image of the face and pass to CoreImage for detection
            AVCaptureConnection *stillConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
            [_stillImageOutput captureStillImageAsynchronouslyFromConnection:stillConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                if(error) {
                    NSLog(@"There was a problem");
                    return;
                }
                
                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                UIImage *smileyImage = [UIImage imageWithData:jpegData];
                _previewLayer.hidden = YES;
                [_session stopRunning];
                self.imageView.hidden = NO;
                self.imageView.image = smileyImage;
                self.activityView.hidden = NO;
                self.statusLabel.text = @"Processing";
                self.statusLabel.hidden = NO;
                
                CIImage *image = [CIImage imageWithData:jpegData];
                [self imageContainsSmiles:image callback:^(BOOL happyFace) {
                    if(happyFace) {
                        self.statusLabel.text = @"Happy Face Found!";
                    } else {
                        self.statusLabel.text = @"Not a good photo...";
                    }
                    self.activityView.hidden = YES;
                    self.retakeButton.hidden = NO;
                }];
            }];
        }
    }
}

- (IBAction)handleRestart:(id)sender
{
    _previewLayer.hidden = NO;
    self.imageView.hidden = YES;
    self.statusLabel.hidden = YES;
    self.activityView.hidden = YES;
    self.retakeButton.hidden = YES;
    [_session startRunning];
}

- (void)imageContainsSmiles:(CIImage *)image callback:(void (^)(BOOL happyFace))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if(!_ciContext) {
            _ciContext = [CIContext contextWithOptions:nil];
        }
        
        if(!_faceDetector) {
            _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:_ciContext options:nil];
        }
        
        // Perform the detections
        NSArray *features = [_faceDetector featuresInImage:image
                                                   options:@{CIDetectorEyeBlink: @YES,
                                                             CIDetectorSmile: @YES,
                                                             CIDetectorImageOrientation: @5}];
        NSLog(@"%lu features", [features count]);
        BOOL happyPicture = NO;
        if([features count] > 0) {
            happyPicture = YES;
        }
        for(CIFeature *feature in features) {
            if ([feature isKindOfClass:[CIFaceFeature class]]) {
                CIFaceFeature *faceFeature = (CIFaceFeature *)feature;
                if(!faceFeature.hasSmile) {
                    happyPicture = NO;
                }
                if(faceFeature.leftEyeClosed || faceFeature.rightEyeClosed) {
                    happyPicture = NO;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(happyPicture);
        });
    });
}

@end
