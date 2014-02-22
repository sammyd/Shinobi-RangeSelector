//
//  MomentumAnimation.m
//  RangeSelector
//
//  Created by Sam Davies on 08/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "MomentumAnimation.h"
#import <ShinobiCharts/SChartEaseOutAnimationCurve.h>

@interface MomentumAnimation () {
    CGFloat animationStartTime, animationDuration;
    void (^positionUpdateBlock)(CGFloat);
    CGFloat startPos, endPos;
    BOOL animating;
    id<SChartAnimationCurve> animationCurve;
}

@end

@implementation MomentumAnimation

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity updateBlock:(void (^)(CGFloat))updateBlock
{
    [self animateWithStartPosition:startPosition
                     startVelocity:velocity
                          duration:0.3f
                       updateBlock:updateBlock];
}

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity duration:(CGFloat)duration updateBlock:(void (^)(CGFloat))updateBlock
{
    [self animateWithStartPosition:startPosition
                     startVelocity:velocity
                          duration:duration
                    animationCurve:[SChartEaseOutAnimationCurve new]
                       updateBlock:updateBlock];
}

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity duration:(CGFloat)duration animationCurve:(id<SChartAnimationCurve>)curve updateBlock:(void (^)(CGFloat))updateBlock
{
    /*
     Calculate the end position. The positions we are dealing with are proportions
     and as such are limited to the range [0,1]. The sign of the velocity is used
     to calculate the direction of the motion, and the magnitude represents how
     far we should expect to travel.
    */
    endPos = startPosition + (velocity * duration) / 5;
    
    // Fix to the limits
    if (endPos < 0) {
        endPos = 0;
    }
    if (endPos > 1) {
        endPos = 1;
    }
    
    // Save off the required variables as ivars
    positionUpdateBlock = updateBlock;
    startPos = startPosition;
    
    // Start an animation loop
    animationStartTime = CACurrentMediaTime();
    animationDuration = duration;
    animationCurve = curve;
    animating = YES;
    [self continueAnimation];
    
}

- (void)continueAnimation
{
    if (CACurrentMediaTime() > animationStartTime + animationDuration) {
        // We've finished the alloted animation time. Stop animating
        animating = NO;
    }
    
    if (animating) {
        // Let's update the position
        CGFloat currentTemporalProportion = (CACurrentMediaTime() - animationStartTime) / animationDuration;
        CGFloat currentSpatialProportion = [animationCurve valueAtTime:currentTemporalProportion];
        CGFloat currentPosition = (endPos - startPos) * currentSpatialProportion + startPos;
        
        // Call the block which will perform the repositioning
        positionUpdateBlock(currentPosition);
        
        // Recurse. We aim here for 20 updates per second.
        [self performSelector:@selector(continueAnimation) withObject:nil afterDelay:0.05f];
    }
}

- (void)stopAnimation
{
    animating = NO;
}

@end
