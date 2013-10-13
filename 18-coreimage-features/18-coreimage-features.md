# iOS7 Day-by-Day: Day 18
## Detecting Face Features with CoreImage

### Introduction

Face detection has been present in iOS since iOS 5, in both AVFoundation and
CoreImage. In iOS7, the face detection in CoreImage has been enhanced, to
include feature detection - including looking for smiles and blinking eyes. The
API is nice and easy to use, so we're going to create an app which uses the
face detection in AVFoundation to determine when to take a photo, and then will
let the user know whether or not it is a good photo by using CoreImage to search
for smiles and closed eyes.


### Face detection with AVFoundation

Day 16's post was about using AVFoundation to detect and decode QR codes, via
the `AVCaptureMetadataOutput` class. The face detector is used in the same way - 
faces are just metadata objects in the same way that a QR code was. We'll create
a `AVCaptureMetadataOutput` object in the same manner, but with a different
metadata type:

    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [_session addOutput:output];
    // We're only interested in faces
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeFace]];
    // This VC is the delegate. Please call us on the main queue
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

We implement the delegate method as before:

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

This is fairly similar to what we did with QR codes, only now we have added a new
output type to the session - `AVCaptureStillImageOutput`. This allows us to take
a photo of the input at a given moment - which is exactly what 
`captureStillImageAsynchronouslyFromConnection:completionHandler:` does. So, when
we are notified that AVFoundation has detected a face, we take a still image of
the current input, and stop the session.

We create a JPEG representation of the captured image with the following:

    NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];

Now we pop this into an `UIImageView`, and create a `CIImage` version as well, 
in preparation for the CoreImage facial feature detection. We'll take a look at
this `imageContainsSmiles:callback:` method next.


### Feature finding with CoreImage

CoreImage requires a `CIContext` and a `CIDetector`:

    if(!_ciContext) {
        _ciContext = [CIContext contextWithOptions:nil];
    }
    
    if(!_faceDetector) {
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                           context:_ciContext
                                           options:nil];
    }

To get the detector to perform its search, we invoke the `featuresInImage:options:`
method:

    NSArray *features = [_faceDetector featuresInImage:image
                                           options:@{CIDetectorEyeBlink: @YES,
                                                     CIDetectorSmile: @YES,
                                                     CIDetectorImageOrientation: @5}];

In order to get the detector to perform smile and blink detection we have to
specify as such in the detector options (`CIDetectorEyeBlink` and `CIDetectorSmile`).
The CoreImage face detector is orientation specific, and therefore we're also
setting the detector orientation here to match the orientation in which the app
has been designed.

Now we can loop through the features array (which contains `CIFaceFeature` objects)
and interrogate each one to find out whether it contains a smile or blinking eyes:

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

Finally we perform the callback on the main queue:

    dispatch_async(dispatch_get_main_queue(), ^{
        callback(happyPicture);
    });

Our callback method updates the label to describe whether or not a good photo was
taken:

    [self imageContainsSmiles:image callback:^(BOOL happyFace) {
        if(happyFace) {
            self.statusLabel.text = @"Happy Face Found!";
        } else {
            self.statusLabel.text = @"Not a good photo...";
        }
        self.activityView.hidden = YES;
        self.retakeButton.hidden = NO;
    }];

If you run the app up you can see how good the CoreImage facial feature detector
is:

![miserable](img/face-miserable1.png)
![miserable](img/face-miserable2.png)
![winking](img/face-winking.png)
![happy](img/face-happy.png)

In addition to these properties, it's also possible to find the positions of the
different facial features, such as the eyes and the mouth.


### Conclusion

Although not a ground-breaking addition to the API, this advance in the CoreImage
facial detector adds a nice ability to interrogate your facial images. It could
make a nice addition to a photography app - helping users take all the 'selfies'
they need.



