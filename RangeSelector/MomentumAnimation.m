//
//  MomentumAnimation.m
//  RangeSelector
//
//  Created by Sam Davies on 08/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import "MomentumAnimation.h"

@interface MomentumAnimation () {
    CGFloat animationStartTime, animationDuration;
    void (^positionUpdateBlock)(CGFloat);
    CGFloat startPos, endPos;
    BOOL animating;
    SChartAnimationCurve animationCurve;
}

@end

@implementation MomentumAnimation

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity updateBlock:(void (^)(CGFloat))updateBlock
{
    [self animateWithStartPosition:startPosition startVelocity:velocity updateBlock:updateBlock duration:0.3f];
}

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity updateBlock:(void (^)(CGFloat))updateBlock duration:(CGFloat)duration
{
    [self animateWithStartPosition:startPosition startVelocity:velocity updateBlock:updateBlock duration:duration animationCurve:SChartAnimationCurveEaseOut];
}

- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity updateBlock:(void (^)(CGFloat))updateBlock duration:(CGFloat)duration animationCurve:(SChartAnimationCurve)curve
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
    [self animationRecursion];
    
}

- (void)animationRecursion
{
    if (CACurrentMediaTime() > animationStartTime + animationDuration) {
        animating = NO;
    }
    
    if (animating) {
        // Let's update the position
        CGFloat currentTemporalProportion = (CACurrentMediaTime() - animationStartTime) / animationDuration;
        CGFloat currentSpatialProportion = [SChartAnimationCurveEvaluator evaluateCurve:animationCurve atPosition:currentTemporalProportion];
        CGFloat currentPosition = (endPos - startPos) * currentSpatialProportion + startPos;
        
        // Call the block which will perform the repositioning
        positionUpdateBlock(currentPosition);
        
        // Recurse
        [self performSelector:@selector(animationRecursion) withObject:nil afterDelay:0.05f];
    }
}

- (void)stopAnimation
{
    animating = NO;
}

@end
