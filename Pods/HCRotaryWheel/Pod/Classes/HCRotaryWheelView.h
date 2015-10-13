//
//  HCRotaryWheelView.h
//  RotaryWheel
//
//  Created by Hannah Carney on 05/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotaryImageView.h"

IB_DESIGNABLE

@protocol RotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(int)currentSector;

@end

@interface HCRotaryWheelView : UIView

@property (weak) id <RotaryProtocol> delegate;
@property (nonatomic) IBInspectable UIColor *background;
@property (nonatomic) IBInspectable int numberOfSections;
@property (nonatomic) IBInspectable RotaryImageView *sectorView;
@property (nonatomic) IBInspectable UIImage *rotaryImage1;
@property (nonatomic) IBInspectable UIImage *rotaryImage2;
@property (nonatomic) IBInspectable UIImage *rotaryImage3;
@property (nonatomic) IBInspectable UIImage *rotaryImage4;
@property (nonatomic) IBInspectable UIImage *rotaryImage5;
@property (nonatomic) IBInspectable UIImage *rotaryImage6;
@property (nonatomic) UIView *container;
@property (nonatomic) NSTimer *timer;
@property CGAffineTransform startTransform;
@property (nonatomic) NSMutableArray *sectors;
@property int currentSector;
@property (nonatomic) BOOL timerDoesExist;

-(void)rotate;
-(void)getPlacement;
-(void)stopTimer;
-(void)startTimer;
-(BOOL)timerExists;

@end