# iOS7 Day-by-Day: Day 16
## Decoding QR Codes with AVFoundation

### Introduction

Yesterday we looked at some of the new filters available in CoreImage, and
discovered that in iOS7 we now have the ability to generate QR codes. Well, given
that we can create them you might imagine that it would be helpful to be able
to decode them as well, and you aren't about to be disappointed. In the 17th
installment of DbD we're going to take a look at how to use some new features
in the AVFoundation framework to decode (amongst other things) QR codes.


### AVFoundation pipeline

AVFoundation is a large framework which facilitates creating, editing, display and
capture of multimedia. This post isn't meant to be an introduction to AVFoundation,
but we'll cover the basics of getting a live feed from the camera to appear on
the screen, since it's this we'll use to extract QR codes. In order to use
AVFoundation we need to import the framework:

    @import AVFoundation;

When capturing media, we use the `AVCaptureSession` class as the core of our
pipeline. We then need to add inputs and outputs to complete the session. We'll
set this up in the `viewDidLoad` method of our view controller. Firstly, create
a session:

    AVCaptureSession *session = [[AVCaptureSession alloc] init];

We need to add the main camera as an input to this session. An input is a
`AVCaptureDeviceInput` object, which is created from a `AVCaptureDevice` object:

    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        // Add the input to the session
        [session addInput:input];
    } else {
        NSLog(@"error: %@", error);
        return;
    }

Here we get a reference to the default video input device, which will be the rear
camera on devices with multiple cameras. Then we create an `AVCaptureDeviceInput`
object using the device, and then add it to the session.

In order to get the video to appear on the screen we need to create a
`AVCaptureVideoPreviewLayer`. This is a `CALayer` subclass, which, when added
to a session will display the current video output of the session. Given that we
have an ivar called `_previewLayer` of type `AVCaptureVideoPreviewLayer`:

    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.bounds = self.view.bounds;
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.layer addSublayer:_previewLayer];

The `videoGravity` property is used to specify how the video should appear within
the bounds of the layer. Since the aspect-ratio of the video is not equal to that
of the screen, we want to chop off the edges of the video so that it appears to
fill the entire screen, hence the use of `AVLayerVideoGravityResizeAspectFill`.
We add this layer as a sublayer of the view's layer.

Now this is set up, all that remains is to start the session:

    // Start the AVSession running
    [session startRunning];

If you run the app up now (on a device) then you'll be able to see the camera's
output on the screen - magic.

![Preview Layer](img/qr-preview.png)

### Capturing metadata

You've been able to do what we've achieved so far since iOS5, but in this section
we're going to do some stuff which has only been possible since iOS7.

An `AVCaptureSession` can have `AVCaptureOutput` objects attached to it, forming
the end points of the AV pipeline. The `AVCaptureOutput` subclass we're interested
in here is `AVCaptureMetadataOutput`, which detects any metadata from the video
content and outputs it. The output of this class isn't of the form of image or
video, but instead metadata objects which have been extracted from the video feed
itself. Setting this up is as follows:

     *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [session addOutput:output];
    // What different things can we register to recognise?
    NSLog(@"%@", [output availableMetadataObjectTypes]);

Here, we've created a metadata output object, and added it as an output to the
session. Then we've using a method provided to log out a list of the different
metadata types we can register to be informed about:

    2013-10-09 11:10:26.085 CodeScanner[6277:60b] (
        "org.gs1.UPC-E",
        "org.iso.Code39",
        "org.iso.Code39Mod43",
        "org.gs1.EAN-13",
        "org.gs1.EAN-8",
        "com.intermec.Code93",
        "org.iso.Code128",
        "org.iso.PDF417",
        "org.iso.QRCode",
        "org.iso.Aztec"
    )

It's important to note that we have to add our metadata output object to the
session before attempting this, since the available types depend on the input
device. We can see above that we can register to detect QR codes, so let's do that:

    // We're only interested in QR Codes
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];

This is an array, so you can specify as many of the different metadata types as
you wish.

When the metadata output object finds something within the video stream for which
it can generate metadata it tells its delegate, so we need to set the delegate:

    // This VC is the delegate. Please call us on the main queue
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

Since AVFoundation is designed to allow threaded operation, we specify which
queue we want the delegate to be called on as well.

The delegate protocol method we need to adopt is
`AVCaptureMetadataOutputObjectsDelegate`:

    @interface SCViewController () <AVCaptureMetadataOutputObjectsDelegate> {
        AVCaptureVideoPreviewLayer *_previewLayer;
        UILabel *_decodedMessage;
    }
    @end

And the method we need to implement is
`captureOutput:didOutputMetadataObjects:fromConnection:`:

    #pragma mark - AVCaptureMetadataOutputObjectsDelegate
    - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
    {
        for (AVMetadataObject *metadata in metadataObjects) {
            if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)metadata;
                // Update the view with the decoded text
                _decodedMessage.text = [transformed stringValue];
            }
        }
    }

The `metadataObjects` array consists of `AVMetadataObject` objects, which we
inspect to find their type. Since we've only registered to be notified of
QR codes we'll only be getting objects of type `AVMetadataObjectTypeQRCode`.
The `AVMetadataMachineReadableCodeObject` type has a `stringValue` property which
contains the decoded value of whatever metadata object has been detected. Here
we're pushing this string to be displayed in the `_decodedMessage` label, which
was created in `viewDidLoad`:

    // Add a label to display the resultant message
    _decodedMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 75, CGRectGetWidth(self.view.bounds), 75)];
    _decodedMessage.numberOfLines = 0;
    _decodedMessage.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    _decodedMessage.textColor = [UIColor darkGrayColor];
    _decodedMessage.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_decodedMessage];

Running the app up now and pointing it at a QR code will cause the decoded
string to appear at the bottom of the screen:

![Decoding](img/qr-decode.png)


### Drawing the code outline

In addition to providing the decoded text the metadata objects also contain a
bounding box and the locations of the corners of the detected QR code. Our scanner
app would be a lot more intuitive if we displayed the location of the detected
code.

In order to do this we create a `UIView` subclass, which when provided with a 
sequence of points, will connect the dots. This will become clear as we build
it:

    @interface SCShapeView : UIView

    @property (nonatomic, strong) NSArray *corners;

    @end

The `corners` array contains (boxed) `CGPoint` objects, each of which represents
a corner of the shape we wish to draw.

We're going to use a `CAShapeLayer` to draw the points, as this is an extremely
efficient way of drawing shapes:

    @interface SCShapeView () {
        CAShapeLayer *_outline;
    }
    @end

    @implementation SCShapeView

    - (id)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            // Initialization code
            _outline = [CAShapeLayer new];
            _outline.strokeColor = [[[UIColor blueColor] colorWithAlphaComponent:0.8] CGColor];
            _outline.lineWidth = 2.0;
            _outline.fillColor = [[UIColor clearColor] CGColor];
            [self.layer addSublayer:_outline];
        }
        return self;
    }
    @end

Here we create a shape layer, set some appearance properties on it, and add it
to the layer hierarchy. We are yet to set the path of the shape - we'll do that
in the setter for the `corners` property:

    - (void)setCorners:(NSArray *)corners
    {
        if(corners != _corners) {
            _corners = corners;
            _outline.path = [[self createPathFromPoints:corners] CGPath];
        }
    }

This means that as the `corners` property is updated, the shape will be redrawn
in its new position. We've used a utility method to create a `UIBezierPath` from
an `NSArray` of boxed `CGPoint` objects:

    - (UIBezierPath *)createPathFromPoints:(NSArray *)points
    {
        UIBezierPath *path = [UIBezierPath new];
        // Start at the first corner
        [path moveToPoint:[[points firstObject] CGPointValue]];
        
        // Now draw lines around the corners
        for (NSUInteger i = 1; i < [points count]; i++) {
            [path addLineToPoint:[points[i] CGPointValue]];
        }
        
        // And join it back to the first corner
        [path addLineToPoint:[[points firstObject] CGPointValue]];
        
        return path;
    }

This is fairly self-explanatory - just using the API of `UIBezierPath` to create
a completed shape.

Now we've created this shape view, we need to use it in our view controller to
show the detected QR code. Let's create an ivar, and create the object in 
`viewDidLoad`:

    _boundingBox = [[SCShapeView alloc] initWithFrame:self.view.bounds];
    _boundingBox.backgroundColor = [UIColor clearColor];
    _boundingBox.hidden = YES;
    [self.view addSubview:_boundingBox];

Now we need to update this view in the metadata output delegate method:

    // Transform the meta-data coordinates to screen coords
    AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:metadata];
    // Update the frame on the _boundingBox view, and show it
    _boundingBox.frame = transformed.bounds;
    _boundingBox.hidden = NO;
    // Now convert the corners array into CGPoints in the coordinate system
    //  of the bounding box itself
    NSArray *translatedCorners = [self translatePoints:transformed.corners
                                              fromView:self.view
                                                toView:_boundingBox];
    
    // Set the corners array
    _boundingBox.corners = translatedCorners;

AVFoundation uses a different coordinate system to that used by UIKit when rendering
on the screen, so the first part of this code snippet uses the
`transformedMetadataObjectForMetadataObject:` method on `AVCaptureVideoPreviewLayer`
to translate the coordinate system from AVFoundation, to be in the coordinate
system of our preview layer.

Next we set the frame of our shape overlay to be the same as the bounding box
of the detected code, and update its visibility.

We now need to set the `corners` property on the shape view so that the overlay
is positioned correctly, but before we do that we need to change coordinate
systems again.

The `corners` property on `AVMetadataMachineReadableCodeObject` is an `NSArray`
of dictionary objects, each of which have `X` and `Y` keys. Since we translated
the coordinate systems, the values associated with the corners refer to the video
preview layer - but we want them to be in terms of our shape overlay. Therefore
we use the following utility method:

    - (NSArray *)translatePoints:(NSArray *)points fromView:(UIView *)fromView toView:(UIView *)toView
    {
        NSMutableArray *translatedPoints = [NSMutableArray new];

        // The points are provided in a dictionary with keys X and Y
        for (NSDictionary *point in points) {
            // Let's turn them into CGPoints
            CGPoint pointValue = CGPointMake([point[@"X"] floatValue], [point[@"Y"] floatValue]);
            // Now translate from one view to the other
            CGPoint translatedPoint = [fromView convertPoint:pointValue toView:toView];
            // Box them up and add to the array
            [translatedPoints addObject:[NSValue valueWithCGPoint:translatedPoint]];
        }
        
        return [translatedPoints copy];
    }

Here we use `convertPoint:toView:` from `UIView` to change coordinate systems, and
return an `NSArray` containing `NSValue` boxed `CGPoint` objects instead of
`NSDictionary` objects. We can then pass this to the `corners` property of our
shape view.

If you run the app up now you'll see the bounding box of the code highlighted as
well as the decoded message:

![Bounding box 1](img/qr-bounding1.png)
![Bounding box 2](img/qr-bounding2.png)

The final bits of code in the example app cause the decoded message and bounding
box to disappear after a certain amount of time. This prevents the box from
staying on the screen when there are no QR codes present.

    - (void)startOverlayHideTimer
    {
        // Cancel it if we're already running
        if(_boxHideTimer) {
            [_boxHideTimer invalidate];
        }
        
        // Restart it to hide the overlay when it fires
        _boxHideTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                         target:self
                                                       selector:@selector(removeBoundingBox:)
                                                       userInfo:nil
                                                        repeats:NO];
    }

Each time this method gets called it resets the timer, which when it finally gets
fired will call the following method:

    - (void)removeBoundingBox:(id)sender
    {
        // Hide the box and remove the decoded text
        _boundingBox.hidden = YES;
        _decodedMessage.text = @"";
    }

We call the timer method at the end of the delegate method:

    // Start the timer which will hide the overlay
    [self startOverlayHideTimer];


### Conclusion

AVFoundation is a very complex and powerful framework, and in iOS7 it just got
better. Detecting different barcodes live used to be quite a difficult task on
mobile devices, but with introductions of these new metadata output types it
is now really simple and efficient. Whether or not we should be using QR code
is a different question... but at least it's easy if we want to =)
