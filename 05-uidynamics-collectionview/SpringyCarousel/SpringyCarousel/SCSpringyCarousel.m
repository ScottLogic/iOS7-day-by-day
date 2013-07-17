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
    NSMutableArray *_newItemBehaviors;
    NSMutableDictionary *_springs;
    UIDynamicBehavior *_newItemBehavior;
}

- (id)initWithItemSize:(CGSize)size
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // Save off the size
        _itemSize = size;
        _newItemBehaviors = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Overridden methods
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGFloat scrollDelta = newBounds.origin.x - self.collectionView.bounds.origin.x;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    for (UIAttachmentBehavior *behavior in [_springs allValues]) {
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
    [UIView setAnimationsEnabled:NO];
    // We update the section inset before we layout
    self.sectionInset = UIEdgeInsetsMake(CGRectGetHeight(self.collectionView.bounds) - _itemSize.height, 0, 0, 0);
    [super prepareLayout];
    
    if(!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        _dynamicAnimator.delegate = self;
        
        _springs = [NSMutableDictionary dictionary];
    }
    
    // Get a list of the objects around the current view
    CGRect expandedViewPort = self.collectionView.bounds;
    expandedViewPort.origin.x -= 2 * _itemSize.width;
    expandedViewPort.size.width += 4 * _itemSize.width;
    NSArray *currentItems = [super layoutAttributesForElementsInRect:expandedViewPort];
    
    // Find the items we need to add springs to
    NSMutableSet *toAdd = [NSMutableSet setWithArray:currentItems];
    [toAdd minusSet:[NSSet setWithArray:[_springs allKeys]]];

    // Create the newly required attachement behaviors
    for (UICollectionViewLayoutAttributes *attr in toAdd) {
        // Create an attachment behaviour
        UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:attr attachedToAnchor:[attr center]];
        behavior.length = 0;
        behavior.damping = 0.8;
        behavior.frequency = 0.8;
        // Add the new behavior to the animator
        [_dynamicAnimator addBehavior:behavior];
        // And keep it in the _springs dictionary
        [_springs setObject:behavior forKey:attr];
    }
    
    // Let's find the ones we need to remove
    NSMutableSet *toRemove = [NSMutableSet setWithArray:[_springs allKeys]];
    [toRemove minusSet:[NSSet setWithArray:currentItems]];
    
    // Let's remove any we no longer need
    for (UICollectionViewLayoutAttributes *attr in toRemove) {
        UIDynamicBehavior *behaviorToRemove = _springs[attr];
        [_dynamicAnimator removeBehavior:behaviorToRemove];
        // And throw from the _springs dictionary
        [_springs removeObjectForKey:attr];
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


- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    for (UICollectionViewUpdateItem *updateItem in updateItems) {
        if(updateItem.updateAction == UICollectionUpdateActionInsert) {
            
            /* We need to loop through all the visible ones and update them */
            NSArray *curIndexPaths = [self.collectionView indexPathsForVisibleItems];
            
            [curIndexPaths enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if(idx > 0) {
                    NSIndexPath *idxPath = (NSIndexPath*)obj;
                    if(idxPath.item >= updateItem.indexPathAfterUpdate.item) {
                        // These ones need moving to the right
                        // It's going to try and move from one attr to another. Need to update the springs appropriately
                        UICollectionViewLayoutAttributes *curAttr = [self layoutAttributesForItemAtIndexPath:idxPath];
                        UICollectionViewLayoutAttributes *newAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:(idxPath.item + 1) inSection:idxPath.section]];
                        
                        // Need to push
                        newAttr.center = curAttr.center;
                        [_dynamicAnimator updateItemFromCurrentState:newAttr];
                    }
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
            [_dynamicAnimator updateItemFromCurrentState:insertionPointAttr];
            
            // Create the appropriate behaviors
            UIDynamicBehavior *newItemBehavior = [[UIDynamicBehavior alloc] init];
            
            // Create the separate behaviors
            UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[attr]];
            gravity.yComponent = 0.5;
            UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[attr]];
            collision.translatesReferenceBoundsIntoBoundary = YES;

            
            // Update some dynamic properties
            UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[attr]];
            itemBehavior.elasticity = 1;
            itemBehavior.allowsRotation = NO;
            
            [newItemBehavior addChildBehavior:gravity];
            [newItemBehavior addChildBehavior:collision];
            [collision addChildBehavior:itemBehavior];
            
            // Add the behavior to the animator
            [_dynamicAnimator addBehavior:newItemBehavior];

            // Save the behavior
            [_newItemBehaviors addObject:newItemBehavior];
            
            // Update the position in the animator
            [_dynamicAnimator updateItemFromCurrentState:attr];
        }
    }
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return [_dynamicAnimator layoutAttributesForCellAtIndexPath:itemIndexPath];
}

#pragma mark - UIDynamicAnimatorDelegate methods
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    // If the dynamic animator has paused, then we remove the _newItemBehavior
    if([_newItemBehaviors count] > 0) {
        for (UIDynamicBehavior *behavior in _newItemBehaviors) {
            [_dynamicAnimator removeBehavior:behavior];
        }
        [_newItemBehaviors removeAllObjects];
    }
}

@end
