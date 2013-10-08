//
//  SCSecondViewController.m
//  ImageFilter
//
//  Created by Sam Davies on 08/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SCQRGeneratorViewController.h"

@interface SCQRGeneratorViewController ()

@end

@implementation SCQRGeneratorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)handleGenerateButtonPressed:(id)sender {
    // Disable the UI
    [self setUIElementsAsEnabled:NO];
    [self.stringTextField resignFirstResponder];

    // Get the string
    NSString *stringToEncode = self.stringTextField.text;
    
    // Generate the image
    CIImage *qrCode = [self createQRForString:stringToEncode];
    
    // Convert to an UIImage
    UIImage *qrCodeImg = [self createUIImageFromCIImageViaCGGImage:qrCode];
    
    // And push the image on to the screen
    self.qrImageView.image = qrCodeImg;
    
    // Re-enable the UI
    [self setUIElementsAsEnabled:YES];
}

#pragma mark - Utility methods
- (CIImage *)createQRForString:(NSString *)qrString
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return qrFilter.outputImage;
}

- (void)setUIElementsAsEnabled:(BOOL)enabled
{
    self.generateButton.enabled = enabled;
    self.stringTextField.enabled = enabled;
}

- (UIImage *)createUIImageFromCIImageViaCGGImage:(CIImage *)image
{
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return newImage;
}
@end
