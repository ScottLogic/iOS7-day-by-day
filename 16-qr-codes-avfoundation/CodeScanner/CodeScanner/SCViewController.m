//
//  SCViewController.m
//  CodeScanner
//
//  Created by Sam Davies on 08/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SCViewController.h"
@import AVFoundation;

@interface SCViewController () <AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        [session addInput:input];
    } else {
        NSLog(@"error: %@", error);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    [session startRunning];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *qrCode = nil;
    for (AVMetadataObject *metadata in metadataObjects) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            qrCode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
            break;
        }
    }
    NSLog(@"QRCode: %@", qrCode);
}


@end
