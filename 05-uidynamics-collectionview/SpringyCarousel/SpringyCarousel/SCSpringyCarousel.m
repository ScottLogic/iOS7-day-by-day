//
//  SCSpringyCarousel.m
//  SpringyCarousel
//
//  Created by Sam Davies on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCSpringyCarousel.h"

@implementation SCSpringyCarousel {
    CGSize _itemSize;
    UIDynamicAnimator *_dynamicAnimator;
}

- (id)initWithItemSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Save off the size
        _itemSize = size;
    }
    return self;
}

#pragma mark - Overridden methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGFloat scrollDelta = newBounds.origin.x - self.collectionView.bounds.origin.x;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in _dynamicAnimator.behaviors) {
        CGPoint anchorPoint = behavior.anchorPoint;
        CGFloat distFromTouch = ABS(anchorPoint.x - touchLocation.x);
        
        
        UICollectionViewLayoutAttributes *attr = [behavior.items firstObject];
        CGPoint center = attr.center;
        CGFloat scrollFactor = MIN(1, distFromTouch / 500);
        
        center.x += scrollDelta * scrollFactor;
        attr.center = center;
        
        [_dynamicAnimator updateItemFromCurrentState:attr];
    }
    
    return NO;
}

- (void)prepareLayout
{
    // We update the section inset before we layout
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - _itemSize.height, 0, 0, 0);
    [super prepareLayout];
    
    if(!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        
        // Let's get a list of all the objects managed by the collection view
        CGSize contentSize = [self collectionViewContentSize];
        NSArray *collectionItems = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        
        for (UICollectionViewLayoutAttributes *attr in collectionItems) {
            // Create an attachment behaviour
            UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:attr attachedToAnchor:[attr center]];
            behavior.length = 0;
            behavior.damping = 0.5;
            behavior.frequency = 0.8;
            
            [_dynamicAnimator addBehavior:behavior];
        }
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

@end
