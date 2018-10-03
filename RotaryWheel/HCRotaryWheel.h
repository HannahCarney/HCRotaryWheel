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
@property (nonatomic) IBInspectable float imageSize;
@property (nonatomic) IBInspectable float imageSpacing;
@property (nonatomic) IBInspectable double minAlphavalue;
@property (nonatomic) IBInspectable float maxAlphavalue;
@property (nonatomic) IBInspectable UIColor *color1;
@property (nonatomic) IBInspectable UIColor *color2;
@property (nonatomic) IBInspectable UIColor *color3;
@property (nonatomic) IBInspectable UIColor *color4;
@property (nonatomic) IBInspectable UIColor *color5;
@property (nonatomic) IBInspectable UIColor *color6;
@property (nonatomic) IBInspectable UIColor *color7;
@property (nonatomic) IBInspectable UIColor *color8;
@property (nonatomic) IBInspectable UIColor *color9;
@property (nonatomic) IBInspectable UIColor *color10;
@property (nonatomic) IBInspectable UIColor *color11;
@property (nonatomic) IBInspectable UIColor *color12;
@property (nonatomic) IBInspectable UIImage *image1;
@property (nonatomic) IBInspectable UIImage *image2;
@property (nonatomic) IBInspectable UIImage *image3;
@property (nonatomic) IBInspectable UIImage *image4;
@property (nonatomic) IBInspectable UIImage *image5;
@property (nonatomic) IBInspectable UIImage *image6;
@property (nonatomic) IBInspectable UIImage *image7;
@property (nonatomic) IBInspectable UIImage *image8;
@property (nonatomic) IBInspectable UIImage *image9;
@property (nonatomic) IBInspectable UIImage *image10;
@property (nonatomic) IBInspectable UIImage *image11;
@property (nonatomic) IBInspectable UIImage *image12;


@property (nonatomic) RotaryImageView *sectorView;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, retain) NSTimer *timer;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectors;
@property int currentSector;
@property BOOL turnOnDropShadow;
@property (nonatomic) BOOL timerDoesExist;
@property (nonatomic) BOOL turnOnColorForCurrent;
@property (nonatomic) UIColor* colorForCurrent;
-(void)rotate;
-(void)getPlacement;
-(void)stopTimer;
-(void)startTimer;
-(BOOL)timerExists;

@end
