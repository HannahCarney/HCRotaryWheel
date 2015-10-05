//
//  RotaryWheelControl.h
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCRotaryWheel.h"

@interface RotaryWheelControl : UIControl

@property CGAffineTransform startTransform;

-(void)setUpControlWithSelf:(HCRotaryWheel*)rotaryWheel andImageArray:(NSArray *)imageArray;

@end
