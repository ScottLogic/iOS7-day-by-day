//
//  SCNewtonsCradleView.m
//  NewtonsCradle
//
//  Created by Sam Davies on 02/07/2013.
//  Copyright (c) 2013 ShinobiControls. All rights reserved.
//

#import "SCNewtonsCradleView.h"
#import "SCBallBearingView.h"

@implementation SCNewtonsCradleView {
    NSArray *_ballBearings;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehaviour;
    NSArray *_attachmentBehaviours;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBallBearings];
        [self applyDynamicBehaviours];
        
        _userDragBehaviour = [[UIPushBehavior alloc] initWithItems:@[_ballBearings[0]] mode:UIPushBehaviorModeInstantaneous];
        _userDragBehaviour.xComponent = -10;
        [_animator addBehavior:_userDragBehaviour];
    }
    return self;
}

- (void)createBallBearings
{
    NSMutableArray *bbArray = [NSMutableArray array];
    NSUInteger numberBalls = 5;
    CGFloat ballSize = CGRectGetWidth(self.bounds) / (3.0 * (numberBalls - 1));
    
    for (NSUInteger i=0; i<numberBalls; i++) {
        SCBallBearingView *bb = [[SCBallBearingView alloc] initWithFrame:CGRectMake(0, 0, ballSize - 1, ballSize - 1)];
        
        CGFloat x = CGRectGetWidth(self.bounds) / 3.0 + i * ballSize;
        CGFloat y = CGRectGetHeight(self.bounds) / 2.0;
        bb.center = CGPointMake(x, y);
        
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBallBearingPan:)];
        [bb addGestureRecognizer:gesture];
        [bbArray addObject:bb];
        [self addSubview:bb];
    }
    _ballBearings = [NSArray arrayWithArray:bbArray];
}


- (void)handleBallBearingPan:(UIPanGestureRecognizer *)recogniser
{
    if (recogniser.state == UIGestureRecognizerStateBegan) {
        if(_userDragBehaviour) {
            [_animator removeBehavior:_userDragBehaviour];
        }
        _userDragBehaviour = [[UIPushBehavior alloc] initWithItems:@[recogniser.view] mode:UIPushBehaviorModeContinuous];
        [_animator addBehavior:_userDragBehaviour];
    }
    _userDragBehaviour.xComponent = [recogniser translationInView:self].x / 3.f;
    
    if (recogniser.state == UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_userDragBehaviour];
        _userDragBehaviour = nil;
    }
}

- (void)applyDynamicBehaviours
{   
    // Create the composite behaviour
    UIDynamicBehavior *behaviour = [[UIDynamicBehavior alloc] init];
    
    
    NSMutableArray *attachmentBehaviours = [NSMutableArray array];
    for(id<UIDynamicItem> ballBearing in _ballBearings)
    {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviourForBallBearing:ballBearing];
        [behaviour addChildBehavior:attachmentBehavior];
        [attachmentBehaviours addObject:behaviour];
    }
    _attachmentBehaviours = [NSArray arrayWithArray:attachmentBehaviours];
    
    [behaviour addChildBehavior:[self createGravityBehaviourForObjects:_ballBearings]];
    
    [behaviour addChildBehavior:[self createCollisionBehaviourForObjects:_ballBearings]];
    
    // Apply correct dynamic item behaviour
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:_ballBearings];
    itemBehaviour.elasticity = 1.0;
    itemBehaviour.allowsRotation = NO;
    itemBehaviour.resistance = 2.0;
    [behaviour addChildBehavior:itemBehaviour];
    
    // Create the animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    [_animator addBehavior:behaviour];
}

- (UIDynamicBehavior *)createAttachmentBehaviourForBallBearing:(id<UIDynamicItem>)ballBearing
{
    CGPoint anchor = ballBearing.center;
    anchor.y -= CGRectGetHeight(self.bounds) / 4.0;
    // Draw a box at the anchor
    UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueBox.backgroundColor = [UIColor blueColor];
    blueBox.center = anchor;
    [self addSubview:blueBox];
    return [[UIAttachmentBehavior alloc] initWithItem:ballBearing attachedToAnchor:anchor];
}

- (UIDynamicBehavior *)createGravityBehaviourForObjects:(NSArray *)objects
{
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.yComponent = 10;
    return gravity;
}

- (UIDynamicBehavior *)createCollisionBehaviourForObjects:(NSArray *)objects
{    
    return [[UICollisionBehavior alloc] initWithItems:objects];
}



@end
