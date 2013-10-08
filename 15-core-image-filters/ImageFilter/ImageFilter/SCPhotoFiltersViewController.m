//
//  SCPhotoFiltersViewController.m
//  ImageFilter
//
//  Created by Sam Davies on 08/10/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "SCPhotoFiltersViewController.h"
#import "SCLabelledImageCell.h"

@interface SCPhotoFiltersViewController () {
    NSArray *_filters;
    CIImage *_inputImage;
    NSArray *_filteredImages;
}

@end

@implementation SCPhotoFiltersViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _filters = @[@"CIPhotoEffectChrome", @"CIPhotoEffectFade", @"CIPhotoEffectInstant",
                 @"CIPhotoEffectMono", @"CIPhotoEffectNoir", @"CIPhotoEffectProcess",
                 @"CIPhotoEffectTonal", @"CIPhotoEffectTransfer"];
    _inputImage = [CIImage imageWithCGImage:[[UIImage imageNamed:@"shinobi-badge-head.jpg"] CGImage]];
    _filteredImages = [self preFilterImages];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Utility Methods
- (NSArray *)preFilterImages
{
    NSMutableArray *images = [NSMutableArray new];
    for(NSString *filterName in _filters) {
        // Filter the image
        CIFilter *filter = [CIFilter filterWithName:filterName];
        [filter setValue:_inputImage forKey:kCIInputImageKey];
        // Create a CG-back UIImage
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        [images addObject:image];
    }
    
    return [images copy];
}


#pragma mark - UICollectionViewDatasource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_filters count] + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get hold of a cell
    SCLabelledImageCell *cell = (SCLabelledImageCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"FilterImageCell"
                                                                                                     forIndexPath:indexPath];
    
    if(indexPath.row > 0) {
        // Apply to the imageview
        cell.imageView.image = _filteredImages[indexPath.row - 1];
        cell.titleLabel.text = _filters[indexPath.row - 1];
    } else {
        // Let's show the original image in the first cell
        cell.imageView.image = [UIImage imageWithCIImage:_inputImage];
        cell.titleLabel.text = @"Original";
    }
    
    return cell;
}

@end
