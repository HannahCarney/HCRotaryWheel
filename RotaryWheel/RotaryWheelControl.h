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

@property (weak) id <RotaryProtocol> delegate;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;

-(void)setUpControlWithSelf:(HCRotaryWheelView*)rotaryWheel andImageArray:(NSArray *)imageArray;

@end
