//
//  ViewController.h
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCRotaryWheel.h"

@interface ViewController : UIViewController <RotaryProtocol>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet HCRotaryWheelView *rotaryWheelView;

@end

