//
//  UIView+ShakeAnimation.m
//  Flypd
//
//  Created by Developer on 2/19/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "UIView+ShakeAnimation.h"

@implementation UIView (ShakeAnimation)

- (void)shakeView {
    
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint: CGPointMake([self center].x - 4, [self center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:  CGPointMake([self center].x + 4, [self center].y)]];
    [[self layer] addAnimation:animation forKey:@"position"];
}

@end
