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
- (void)addItem:(UICollectionViewLayoutAttributes *)item anchor:(CGPoint)anchor
{
    UIAttachmentBehavior *attachmentBehavior = [self createAttachmentBehaviorForItem:item anchor:anchor];
    // Add the behavior to the animator
    [self.animator addBehavior:attachmentBehavior];
    // And store it in the dictionary. Keyed by the index path
    [_attachmentBehaviors setObject:attachmentBehavior forKey:item.indexPath];
    
    // Also need to add this item to the global behaviors
    [self.gravityBehavior addItem:item];
    [self.collisionBehavior addItem:item];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the attachment behavior from the animator
    UIAttachmentBehavior *attachmentBehavior = self.attachmentBehaviors[indexPath];
    [self.animator removeBehavior:attachmentBehavior];

    
    // Remove the item from the global behaviors
    for(UICollectionViewLayoutAttributes *attr in [self.gravityBehavior.items copy])
    {
        if([attr.indexPath isEqual:indexPath]) {
            [self.gravityBehavior removeItem:attr];
        }
    }
    for (UICollectionViewLayoutAttributes *attr in [self.collisionBehavior.items copy])
    {
        if([attr.indexPath isEqual:indexPath]) {
            [self.collisionBehavior removeItem:attr];
        }
    }
    
    // And remove the entry from our dictionary
    [_attachmentBehaviors removeObjectForKey:indexPath];
}

- (void)updateItemCollection:(NSArray *)items
{
    // Let's find the ones we need to remove. We work in indexPaths here
    NSMutableSet *toRemove = [NSMutableSet setWithArray:[self.attachmentBehaviors allKeys]];
    [toRemove minusSet:[NSSet setWithArray:[items valueForKeyPath:@"indexPath"]]];
    
    // Let's remove any we no longer need
    for (NSIndexPath *indexPath in toRemove) {
        [self removeItemAtIndexPath:indexPath];
    }
    
    // Find the items we need to add springs to. A bit more complicated =(
    // Loop through the items we want
    NSArray *existingIndexPaths = [self currentlyManagedItemIndexPaths];
    for(UICollectionViewLayoutAttributes *attr in items) {
        // Find whether this item matches an existing index path
        BOOL alreadyExists = NO;
        for(NSIndexPath *indexPath in existingIndexPaths) {
            if ([indexPath isEqual:attr.indexPath]) {
                alreadyExists = YES;
            }
        }
        // If it doesn't then let's add it
        if(!alreadyExists) {
            // Need to add
            [self addItem:attr anchor:attr.center];
        }
    }
}

- (NSArray *)currentlyManagedItemIndexPaths
{
    return [[_attachmentBehaviors allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([(NSIndexPath*)obj1 item] < [(NSIndexPath*)obj2 item]) {
            return NSOrderedAscending;
        } else if ([(NSIndexPath*)obj1 item] > [(NSIndexPath*)obj2 item]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
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
