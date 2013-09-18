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

#import "SCNewtonsCradleView.h"
#import "SCBallBearingView.h"

@implementation SCNewtonsCradleView {
    NSArray *_ballBearings;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehavior;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBallBearings];
        [self applyDynamicBehaviors];
        
        // Let's kick the cradle off with a push to start with
        _userDragBehavior = [[UIPushBehavior alloc] initWithItems:@[_ballBearings[0]] mode:UIPushBehaviorModeInstantaneous];
        _userDragBehavior.pushDirection = CGVectorMake(-0.5, 0);
        [_animator addBehavior:_userDragBehavior];
    }
    return self;
}

- (void)createBallBearings
{
    NSMutableArray *bbArray = [NSMutableArray array];
    NSUInteger numberBalls = 5;
    CGFloat ballSize = CGRectGetWidth(self.bounds) / (3.0 * (numberBalls - 1));
    
    for (NSUInteger i=0; i<numberBalls; i++) {
        // Make the balls slightly smaller than the space so they don't quite touch
        SCBallBearingView *bb = [[SCBallBearingView alloc] initWithFrame:CGRectMake(0, 0, ballSize - 1, ballSize - 1)];
        
        // Position it correctly
        CGFloat x = CGRectGetWidth(self.bounds) / 3.0 + i * ballSize;
        CGFloat y = CGRectGetHeight(self.bounds) / 2.0;
        bb.center = CGPointMake(x, y);
        
        
        // Add a gesture recogniser
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBallBearingPan:)];
        [bb addGestureRecognizer:gesture];
        
        // Pop the ball bearing in the array and add it as a subview
        [bbArray addObject:bb];
        [self addSubview:bb];
    }
    _ballBearings = [NSArray arrayWithArray:bbArray];
}

#pragma mark - UIGestureRecognizer target method
- (void)handleBallBearingPan:(UIPanGestureRecognizer *)recognizer
{
    // If we're starting the gesture then create a drag force
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if(_userDragBehavior) {
            [_animator removeBehavior:_userDragBehavior];
        }
        _userDragBehavior = [[UIPushBehavior alloc] initWithItems:@[recognizer.view] mode:UIPushBehaviorModeContinuous];
        [_animator addBehavior:_userDragBehavior];
    }
    
    // Set the force to be proportional to distance the gesture has moved
    _userDragBehavior.pushDirection = CGVectorMake([recognizer translationInView:self].x / 10.f, 0);
    
    // If we're finishing then cancel the behavior to 'let-go' of the ball
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_userDragBehavior];
        _userDragBehavior = nil;
    }
}

#pragma mark - UIDynamics utility methods
- (void)applyDynamicBehaviors
{   
    // Create the composite behavior. This will contain the different child behaviors
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc] init];
    
    // Attach each ball bearing to it's pivot point
    for(id<UIDynamicItem> ballBearing in _ballBearings)
    {
        UIDynamicBehavior *attachmentBehavior = [self createAttachmentBehaviorForBallBearing:ballBearing];
        [behavior addChildBehavior:attachmentBehavior];
    }
    
    // Apply gravity to the ball bearings
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_ballBearings]];
    
    // Apply collision behavior to the ball bearings
    [behavior addChildBehavior:[self createCollisionBehaviorForObjects:_ballBearings]];
    
    // Apply correct dynamic item behavior
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:_ballBearings];
    // Elasticity governs the efficiency of the collisions
    itemBehavior.elasticity = 1.0;
    itemBehavior.allowsRotation = NO;
    itemBehavior.resistance = 2.f;
    [behavior addChildBehavior:itemBehavior];
    
    // Create the animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    // Add the composite behavior
    [_animator addBehavior:behavior];
}


- (UIDynamicBehavior *)createAttachmentBehaviorForBallBearing:(id<UIDynamicItem>)ballBearing
{
    CGPoint anchor = ballBearing.center;
    // The anchor point is vertically above the ball bearing
    anchor.y -= CGRectGetHeight(self.bounds) / 4.0;
    
    // Draw a box at the anchor. This isn't part of the behavior but is good visually
    UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    blueBox.backgroundColor = [UIColor blueColor];
    blueBox.center = anchor;
    [self addSubview:blueBox];
    
    // Create the attachment behavior
    UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:ballBearing
                                                               attachedToAnchor:anchor];
    return behavior;
}

- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects
{
    // Create a gravity behavior
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.magnitude = 10;
    return gravity;
}

- (UIDynamicBehavior *)createCollisionBehaviorForObjects:(NSArray *)objects
{
    // Create a collision behavior
    return [[UICollisionBehavior alloc] initWithItems:objects];
}



@end
