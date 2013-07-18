//
//  SCItemBehaviorManager.h
//  SpringyCarousel
//
//  Created by Sam Davies on 17/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCItemBehaviorManager : NSObject

@property (readonly, strong) UIGravityBehavior *gravityBehavior;
@property (readonly, strong) UICollisionBehavior *collisionBehavior;
@property (readonly, strong) NSDictionary *attachmentBehaviors;
@property (readonly, strong) UIDynamicAnimator *animator;


- (instancetype)initWithAnimator:(UIDynamicAnimator *)animator;

- (void)addItem:(id<UIDynamicItem, NSCopying>)item anchor:(CGPoint)anchor;
- (void)removeItem:(id<UIDynamicItem, NSCopying>)item;
- (void)updateItemCollection:(NSArray*)items;


@end
