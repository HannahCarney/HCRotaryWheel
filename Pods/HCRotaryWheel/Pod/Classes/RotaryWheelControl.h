//
//  RotaryWheelControl.h
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCRotaryWheelView.h"

@interface RotaryWheelControl : UIControl

@property CGAffineTransform startTransform;

-(void)setUpControlWithSelf:(HCRotaryWheelView*)rotaryWheel andImageArray:(NSArray *)imageArray;

@end
