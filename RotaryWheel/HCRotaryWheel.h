//
//  HCRotaryWheel.h
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RotaryImageView.h"

@protocol RotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(int)currentSector;
@end


IB_DESIGNABLE

@interface HCRotaryWheel : UIView

@property (weak) id <RotaryProtocol> delegate;
@property (nonatomic, strong) IBInspectable UIColor* background;
@property (nonatomic) IBInspectable int numberOfSections;
@property (nonatomic) IBInspectable RotaryImageView *sectorView;
@property (nonatomic) IBInspectable UIColor *sectorViewColor1;
@property (nonatomic) IBInspectable UIColor *sectorViewColor2;
@property (nonatomic) IBInspectable UIColor *sectorViewColor3;
@property (nonatomic) IBInspectable UIColor *sectorViewColor4;
@property (nonatomic) IBInspectable UIColor *sectorViewColor5;
@property (nonatomic) IBInspectable UIColor *sectorViewColor6;
@property (nonatomic) IBInspectable UIColor *sectorViewColor7;
@property (nonatomic) IBInspectable UIColor *sectorViewColor8;
@property (nonatomic) IBInspectable UIColor *sectorViewColor9;
@property (nonatomic) IBInspectable UIColor *sectorViewColor10;
@property (nonatomic) IBInspectable UIColor *sectorViewColor11;
@property (nonatomic) IBInspectable UIColor *sectorViewColor12;
@property (nonatomic) IBInspectable UIImage *rotaryImage1;
@property (nonatomic) IBInspectable UIImage *rotaryImage2;
@property (nonatomic) IBInspectable UIImage *rotaryImage3;
@property (nonatomic) IBInspectable UIImage *rotaryImage4;
@property (nonatomic) IBInspectable UIImage *rotaryImage5;
@property (nonatomic) IBInspectable UIImage *rotaryImage6;
@property (nonatomic) IBInspectable UIImage *rotaryImage7;
@property (nonatomic) IBInspectable UIImage *rotaryImage8;
@property (nonatomic) IBInspectable UIImage *rotaryImage9;
@property (nonatomic) IBInspectable UIImage *rotaryImage10;
@property (nonatomic) IBInspectable UIImage *rotaryImage11;
@property (nonatomic) IBInspectable UIImage *rotaryImage12;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, retain) NSTimer *timer;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;
@property BOOL turnOnDropShadow;
@property (nonatomic) BOOL timerDoesExist;
@property (nonatomic) IBInspectable float imageSize;
@property (nonatomic) IBInspectable float imageSpacing;
@property (nonatomic) IBInspectable double minAlphavalue;
@property (nonatomic) IBInspectable float maxAlphavalue;

-(void)rotate;
-(void)getPlacement;
-(void)stopTimer;
-(void)startTimer;
-(BOOL)timerExists;

@end
