//
//  SCSpringyCarousel.m
//  SpringyCarousel
//
//  Created by Sam Davies on 16/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCSpringyCarousel.h"
#import "SCItemBehaviorManager.h"

@implementation SCSpringyCarousel {
    CGSize _itemSize;
    UIDynamicAnimator *_dynamicAnimator;
    SCItemBehaviorManager *_behaviorManager;
}

- (id)initWithItemSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Save off the size
        _itemSize = size;
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        _behaviorManager = [[SCItemBehaviorManager alloc] initWithAnimator:_dynamicAnimator];
    }
    return self;
}

#pragma mark - Overridden methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGFloat scrollDelta = newBounds.origin.x - self.collectionView.bounds.origin.x;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in [_behaviorManager.attachmentBehaviors allValues]) {
        CGPoint anchorPoint = behavior.anchorPoint;
        CGFloat distFromTouch = ABS(anchorPoint.x - touchLocation.x);
        
        UICollectionViewLayoutAttributes *attr = [behavior.items firstObject];
        CGPoint center = attr.center;
        CGFloat scrollFactor = MIN(1, distFromTouch / 500);
        
        center.x += scrollDelta * scrollFactor;
        attr.center = center;
        
        [_dynamicAnimator updateItemUsingCurrentState:attr];
    }
    
    return NO;
}

- (void)prepareLayout
{
    [UIView setAnimationsEnabled:NO];
    // We update the section inset before we layout
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - _itemSize.height, 0, 0, 0);
    [super prepareLayout];
    
    // Get a list of the objects around the current view
    CGRect expandedViewPort = self.collectionView.bounds;
    expandedViewPort.origin.x -= 2 * _itemSize.width;
    expandedViewPort.size.width += 4 * _itemSize.width;
    NSArray *currentItems = [super layoutAttributesForElementsInRect:expandedViewPort];
    
    // We update our behavior collection to just contain the objects we can currently (almost) see
    [_behaviorManager updateItemCollection:currentItems];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if(updateItem.updateAction == UICollectionUpdateActionInsert) {
            
            // Get a list of items, sorted by their indexPath
            NSArray *items = [_behaviorManager currentlyManagedItemIndexPaths];
            // Now loop backwards, updating centers appropriately.
            // We need to get 2 enumerators - copy from one to the other
            NSEnumerator *fromEnumerator = [items reverseObjectEnumerator];
            // We want to skip the lastmost object in the array as we're copying left to right
            [fromEnumerator nextObject];
            // Now enumarate the array - through the 'to' positions
            [items enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSIndexPath *toIndex = (NSIndexPath*)obj;
                NSIndexPath *fromIndex = (NSIndexPath *)[fromEnumerator nextObject];
                
                
                if(fromIndex && fromIndex.item >= updateItem.indexPathAfterUpdate.item) {
                    UICollectionViewLayoutAttributes *toItem = [self layoutAttributesForItemAtIndexPath:toIndex];
                    UICollectionViewLayoutAttributes *fromItem = [self layoutAttributesForItemAtIndexPath:fromIndex];
                    toItem.center = fromItem.center;
                    [_dynamicAnimator updateItemUsingCurrentState:toItem];
                }
            }];
            
            
            // Need to find the initial layout attributes
            UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:updateItem.indexPathAfterUpdate];
            CGPoint center = attr.center;
            CGSize contentSize = [self collectionViewContentSize];
            center.y -= contentSize.height - CGRectGetHeight(attr.bounds);
            attr.center = center;
            
            // Also need to push the current destination location
            UICollectionViewLayoutAttributes *insertionPointAttr = [self layoutAttributesForItemAtIndexPath:updateItem.indexPathAfterUpdate];
            insertionPointAttr.center = attr.center;
            [_dynamicAnimator updateItemUsingCurrentState:insertionPointAttr];
            
            // Create the separate behaviors
            [_behaviorManager.gravityBehavior addItem:attr];
            [_behaviorManager.collisionBehavior addItem:attr];
            
            // Update the position in the animator
            [_dynamicAnimator updateItemUsingCurrentState:attr];
        }
    }
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:itemIndexPath];
}

@end
