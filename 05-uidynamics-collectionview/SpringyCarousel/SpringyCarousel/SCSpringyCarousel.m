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


#pragma mark - Item insertion methods
- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if(updateItem.updateAction == UICollectionUpdateActionInsert) {
            // Reset the springs of the existing items
            [self resetItemSpringsForInsertAtIndexPath:updateItem.indexPathAfterUpdate];
            
            // Where would the flow layout like to place the new cell?
            UICollectionViewLayoutAttributes *attr = [super initialLayoutAttributesForAppearingItemAtIndexPath:updateItem.indexPathAfterUpdate];
            CGPoint center = attr.center;
            CGSize contentSize = [self collectionViewContentSize];
            center.y -= contentSize.height - CGRectGetHeight(attr.bounds);
            
            // Now reset the center of insertion point for the animator
            UICollectionViewLayoutAttributes *insertionPointAttr = [self layoutAttributesForItemAtIndexPath:updateItem.indexPathAfterUpdate];
            insertionPointAttr.center = center;
            [_dynamicAnimator updateItemUsingCurrentState:insertionPointAttr];
        }
    }
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:itemIndexPath];
}


#pragma mark - Utility Methods
- (void)resetItemSpringsForInsertAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        // If the 'from' cell is after the insert then need to reset the springs
        if(fromIndex && fromIndex.item >= indexPath.item) {
            UICollectionViewLayoutAttributes *toItem = [self layoutAttributesForItemAtIndexPath:toIndex];
            UICollectionViewLayoutAttributes *fromItem = [self layoutAttributesForItemAtIndexPath:fromIndex];
            toItem.center = fromItem.center;
            [_dynamicAnimator updateItemUsingCurrentState:toItem];
        }
    }];
}

@end
