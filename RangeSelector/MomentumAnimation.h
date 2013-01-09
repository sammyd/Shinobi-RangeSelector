//
//  MomentumAnimation.h
//  RangeSelector
//
//  Created by Sam Davies on 08/01/2013.
//  Copyright (c) 2013 Shinobi Controls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiCharts/SChartAnimationCurve.h>


/**
 MomentumAnimation is a general purpose 1-dimensional utility class which will
 allows animation of any object.
 */
@interface MomentumAnimation : NSObject

/**
 Default duration of 0.3s and animation curve of SChartAnimationCurveEaseOut
 */
- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity updateBlock:(void (^)(CGFloat position))updateBlock;

/**
 Default animation curve of SChartAnimationCurveEaseOut
 */
- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity duration:(CGFloat)duration updateBlock:(void (^)(CGFloat))updateBlock;

/**
 Creates an animation which begins at a given (normalised) position with a (normalised)
 velocity.
 @param startPosition  The start position of the object. In range [0,1]
 @param startVelocity  The start velocity of the object. Normalised
 @param duration       The duration of the animation (in seconds)
 @param animationCurve The shape of the curve used for animation.
 @param updateBlock    This block will be repeatedly called with new position values
                       These values will be normalised (i.e. in the same space as startPosition)
 */
- (void)animateWithStartPosition:(CGFloat)startPosition startVelocity:(CGFloat)velocity duration:(CGFloat)duration animationCurve:(SChartAnimationCurve)curve updateBlock:(void (^)(CGFloat))updateBlock;

/**
 Cancels any animations which are currently in progress
 */
- (void)stopAnimation;

@end
