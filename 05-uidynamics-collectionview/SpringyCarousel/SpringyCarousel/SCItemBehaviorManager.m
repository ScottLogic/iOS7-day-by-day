//
//  SCItemBehaviorManager.m
//  SpringyCarousel
//
//  Created by Sam Davies on 17/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCItemBehaviorManager.h"

@interface SCItemBehaviorManager () {
    NSMutableDictionary *_attachmentBehaviors;
}

@end

@implementation SCItemBehaviorManager

- (instancetype)initWithAnimator:(UIDynamicAnimator *)animator
{
    self = [super init];
    if(self) {
        _animator = animator;
        _attachmentBehaviors = [NSMutableDictionary dictionary];
        [self createGravityBehavior];
        [self createCollisionBehavior];
        // Add the global behaviors to the animator
        [self.animator addBehavior:self.gravityBehavior];
        [self.animator addBehavior:self.collisionBehavior];
    }
    return self;
}

#pragma mark - API Methods
- (void)addItem:(id<UIDynamicItem, NSCopying>)item anchor:(CGPoint)anchor
{
    UIAttachmentBehavior *attachmentBehavior = [self createAttachmentBehaviorForItem:item anchor:anchor];
    // Add the behavior to the animator
    [self.animator addBehavior:attachmentBehavior];
    // And store it in the dictionary
    [_attachmentBehaviors setObject:attachmentBehavior forKey:item];
    
    // Also need to add this item to the global behaviors
    [self.gravityBehavior addItem:item];
    [self.collisionBehavior addItem:item];
}

- (void)removeItem:(UICollectionViewLayoutAttributes *)item
{
    // Remove the attachment behavior from the animator
    UIAttachmentBehavior *attachmentBehavior = self.attachmentBehaviors[item];
    [self.animator removeBehavior:attachmentBehavior];

    
    // Remove the item from the global behaviors
    for(UICollectionViewLayoutAttributes *attr in [self.gravityBehavior.items copy])
    {
        if([attr.indexPath isEqual:item.indexPath]) {
            [self.gravityBehavior removeItem:attr];
        }
    }
    for (UICollectionViewLayoutAttributes *attr in [self.collisionBehavior.items copy])
    {
        if([attr.indexPath isEqual:item.indexPath]) {
            [self.collisionBehavior removeItem:attr];
        }
    }
    
    // And remove the entry from our dictionary
    [_attachmentBehaviors removeObjectForKey:item];
}

- (void)updateItemCollection:(NSArray *)items
{
    // Let's find the ones we need to remove
    NSMutableSet *toRemove = [NSMutableSet setWithArray:[self.attachmentBehaviors allKeys]];
    [toRemove minusSet:[NSSet setWithArray:items]];
    
    // Let's remove any we no longer need
    for (UICollectionViewLayoutAttributes *attr in toRemove) {
        [self removeItem:attr];
    }
    
    // Find the items we need to add springs to
    NSMutableSet *toAdd = [NSMutableSet setWithArray:items];
    [toAdd minusSet:[NSSet setWithArray:[self.attachmentBehaviors allKeys]]];
    
    // Create the newly required attachement behaviors
    for (UICollectionViewLayoutAttributes *attr in toAdd) {
        [self addItem:attr anchor:attr.center];
    }

}

#pragma mark - Property override
- (NSDictionary *)attachmentBehaviors
{
    return [_attachmentBehaviors copy];
}


#pragma mark - Utility methods
- (void)createGravityBehavior
{
    _gravityBehavior = [[UIGravityBehavior alloc] init];
    _gravityBehavior.magnitude = 0.3;
}

- (void)createCollisionBehavior
{
    _collisionBehavior = [[UICollisionBehavior alloc] init];
    _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    // Need to add item behavior specific to this
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] init];
    itemBehavior.elasticity = 1;
    // Add it as a child behavior
    [_collisionBehavior addChildBehavior:itemBehavior];
}

- (UIAttachmentBehavior *)createAttachmentBehaviorForItem:(id<UIDynamicItem>)item anchor:(CGPoint)anchor
{
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:anchor];
    attachmentBehavior.damping = 0.5;
    attachmentBehavior.frequency = 0.8;
    attachmentBehavior.length = 0;
    return attachmentBehavior;
}

@end
