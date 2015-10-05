//
//  PCCircularProgressView.m
//  DigitalFitness
//
//  Created by Daniel Atherton on 06/07/2015.
//  Copyright (c) 2015 Daniel Atherton. All rights reserved.
//

#import "PCCircularProgressView.h"

@implementation PCCircularProgressView
{
    UIView* bgView;
}

@synthesize lineThickness = _lineThickness;
@synthesize progressColour = _progressColour;
@synthesize outerMargin = _outerMargin;
@synthesize progressPercentage = _progressPercentage;
@synthesize progressBGColour = _progressBGColour;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialSetup];
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialSetup];
        
    }
    return self;
}

-(void)initialSetup
{
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.progressColour = [UIColor whiteColor];
    self.progressBGColour = [UIColor clearColor];
    self.progressPercentage = 75;
    self.lineThickness = 10;
    self.outerMargin  = 21;
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect
{
    CGRect myFrame = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat endAnglePercentage = [self convertProgressPercentageToAngle:_progressPercentage];
    
    
    // Drawing code
    CGPoint centre =CGPointMake(CGRectGetMidX(myFrame), CGRectGetMidY(myFrame));
    //CGFloat radius1 = (myFrame.size.height) / 2.0;
    CGFloat radius2 = (myFrame.size.height - self.lineThickness - self.outerMargin) / 2.0;
    
    CGFloat startAngle = -90*M_PI/180.0;
    CGFloat endAngle = endAnglePercentage*M_PI/180.0;
    CGFloat fullangle = [self convertProgressPercentageToAngle:1.0f];
    
    
    
    
    //DrawBackground
    
    
    CGContextMoveToPoint(ctx, centre.x, centre.y);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, centre.x, centre.y, radius2 ,
                    startAngle, fullangle*M_PI/180.0, NO);
    
    CGColorRef color0 = _progressBGColour.CGColor;
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, color0);
    CGContextSetLineWidth(ctx, (self.lineThickness *2 ) );
    CGContextStrokePath(ctx);
    
    
    //Draw Ring
    
    CGContextMoveToPoint(ctx, centre.x, centre.y);
    CGContextBeginPath(ctx);
    
    CGContextAddArc(ctx, centre.x, centre.y, radius2,
                    startAngle, endAngle, NO);
    
    CGColorRef color =  self.progressColour.CGColor;
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(ctx, color);
    CGContextSetLineWidth(ctx, self.lineThickness);
    CGContextStrokePath(ctx);
    
}

-(CGFloat) convertProgressPercentageToAngle:(CGFloat) progressPercentage
{
    CGFloat angle = 0.0;
    
    if(progressPercentage == 0)
    {
        angle = -89; // make sure some part of the progress bar is visible even when progress in the current level is zero - UX
    }
    else{
        angle = -90 + (360*progressPercentage);
    }
    return angle;
}

-(void)setProgressPercentage:(CGFloat)progressPercentage
{
    if (_progressPercentage > 100)
    {
        progressPercentage = 100;
    }
    if (_progressPercentage < 0)
    {
        progressPercentage = 0;
    }
    _progressPercentage = progressPercentage / 100.0f;
}
-(CGFloat)progressPercentage
{
    return _progressPercentage *100;
}





@end
