//
//  PCCircularProgressView.h
//  DigitalFitness
//
//  Created by Daniel Atherton on 06/07/2015.
//  Copyright (c) 2015 Daniel Atherton. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface PCCircularProgressView : UIView

@property IBInspectable CGFloat lineThickness;
@property IBInspectable CGFloat outerMargin;
@property (nonatomic , strong) IBInspectable UIColor *progressColour;
@property (nonatomic , strong) IBInspectable UIColor *progressBGColour;
@property IBInspectable CGFloat progressPercentage;



@end
