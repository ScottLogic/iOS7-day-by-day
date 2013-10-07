//
//  SCViewController.m
//  FontPalette
//
//  Created by Sam Davies on 05/10/2013.
//  Copyright (c) 2013 shinobicontrols. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set the font on the subheading label
    self.subHeadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    
    // Modify a font with a descriptor
    UIFontDescriptor *bodyFontDesciptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldBodyFontDescriptor = [bodyFontDesciptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    self.boldBodyTextLabel.font = [UIFont fontWithDescriptor:boldBodyFontDescriptor size:0.0];
    
    
    // Create a font descriptor
    UIFontDescriptor *scriptFontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:
                                                          @{UIFontDescriptorFamilyAttribute: @"Zapfino",
                                                            UIFontDescriptorSizeAttribute: @15.0}
                                              ];
    self.scriptTextLabel.font = [UIFont fontWithDescriptor:scriptFontDescriptor size:0.0];
    
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
