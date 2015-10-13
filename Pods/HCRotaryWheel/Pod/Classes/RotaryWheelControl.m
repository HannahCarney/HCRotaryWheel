//
//  RotaryWheelControl.m
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import "RotaryWheelControl.h"

@implementation RotaryWheelControl
{
    NSArray *imArray;
    CGPoint touchPoint;
    CGPoint touchPoint2;
    NSInteger dist;
    HCRotaryWheelView *wheel;
}

static float deltaAngle;
static float minAlphavalue = 0.6;

@synthesize startTransform;

-(void)setUpControlWithSelf:(HCRotaryWheelView*)rotaryWheel andImageArray:(NSArray *)imageArray
{
    wheel = rotaryWheel;
    imArray = imageArray;
}

- (void) stopTimer
{
    NSLog(@"stopping Timer %@", wheel.timer.description);
    [wheel.timer invalidate];
    wheel.timer = nil;
    wheel.timerDoesExist = NO;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
    // 1 - Get touch position
    touchPoint = [touch locationInView:self];
    // 1.1 - Get the distance from the center
    dist = [self calculateDistanceFromCenter:touchPoint];
    // 1.2 - Filter out touches too close to the center
    if  (dist < 20)
    {
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    // forcing a tap to be on the ferrule
    // 2 - Calculate distance from center
    float dx = touchPoint.x - wheel.container.center.x;
    float dy = touchPoint.y - wheel.container.center.y;
    // 3 - Calculate arctangent value
    deltaAngle = atan2(dy,dx);
    // 4 - Save current transform
    startTransform = wheel.container.transform;
    for (RotaryImageView *view in imArray)
    {
        view.startTranform = view.transform;
    }
    
    // 5 - Set current sector's alpha value to the minimum value
    UIImageView *im = [self getSectorByValue:wheel.currentSector];
    im.alpha = minAlphavalue;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    CGFloat radians = atan2f(wheel.container.transform.b, wheel.container.transform.a);
    NSLog(@"rad is %f", radians);
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x  - wheel.container.center.x;
    float dy = pt.y  - wheel.container.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    wheel.container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    for (RotaryImageView *view in imArray)
    {
        view.transform = CGAffineTransformRotate(view.startTranform, angleDifference);
    }
    return YES;
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    touchPoint2 = [touch locationInView:self];
    float dx = touchPoint2.x - wheel.container.center.x;
    float dy = touchPoint2.y - wheel.container.center.y;
    float ang = atan2(dy,dx);
    if (touchPoint.x - touchPoint2.x < 10 && touchPoint.y - touchPoint2.y < 10 && touchPoint.y - touchPoint2.y > -10)
    {
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UIImageView *im = [self getSectorByValue:wheel.currentSector];
            im.alpha = minAlphavalue;
            CGAffineTransform t = CGAffineTransformRotate(wheel.container.transform, 1.047 - ang + .683);
            wheel.container.transform = t;
            for (RotaryImageView *view in imArray)
            {
                view.transform = CGAffineTransformRotate(view.transform, -1.047 + ang - .683);
            }
        }completion:nil];
        
    }
    [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];
    [wheel getPlacement];
}

- (UIImageView *) getSectorByValue:(int)value {
    UIImageView *res;
    NSArray *views = [wheel.container subviews];
    for (UIImageView *im in views) {
        if (im.tag == value)
            res = im;
    }
    return res;
}

@end
