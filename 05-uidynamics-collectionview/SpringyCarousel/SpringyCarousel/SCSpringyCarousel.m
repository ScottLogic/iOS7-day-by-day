//
//  SCSpringyCarousel.m
//  SpringyCarousel
//
//  Created by Sam Davies on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCSpringyCarousel.h"

@implementation SCSpringyCarousel {
    CGSize itemSize;
}

- (id)initWithItemSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Save off the size
        itemSize = size;
    }
    return self;
}

#pragma mark - Overridden methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // We need to update the section inset to ensure we stay at the bottom
    return YES;
}

- (void)prepareLayout
{
    // We update the section inset before we layout
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - itemSize.height, 0, 0, 0);
    [super prepareLayout];
}

@end
