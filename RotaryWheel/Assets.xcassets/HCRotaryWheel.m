//
//  HCRotaryWheelView.m
//  DigitalFitness
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Daniel Atherton. All rights reserved.
//

#import "HCRotaryWheel.h"
#import "RotaryImageView.h"
#import "RotarySector.h"
#import "RotaryWheelControl.h"

@implementation HCRotaryWheelView
{
    NSMutableArray *imageArray;
    NSMutableArray *sectorArray;
}

HCRotaryWheelView *wheel = nil;

static float minAlphavalue = 0.6;
static float maxAlphavalue = 1.0;

//@synthesize background;
@synthesize numberOfSections = _numberOfSections;
@synthesize startTransform;
@synthesize sectors;
@synthesize delegate, container;
@synthesize currentSector;
@synthesize timer;
@synthesize timerDoesExist;

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
    _background = [UIColor redColor];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.numberOfSections = 6;
//    [self getInterface];
 

}

-(void)getInterface
{
//    wheel = [[HCRotaryWheelView alloc] initWithFrame:self.bounds andDelegate:self];
//    wheel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self addSubview:wheel];
}

//-(void)awakeFromNib
//{
//    wheel.backgroundColor = _background;
//}

- (void) wheelDidChangeValue:(int)currentSector {
    NSLog(@"changed value");
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect myFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    wheel.background = _background;

    [_background set];

    imageArray = [NSMutableArray array];
    sectorArray = [NSMutableArray array];
    // 2 - Set properties
        
    self.delegate = self;
    // 3 - Draw wheel
    self.currentSector = 0;
   
    container = [[UIView alloc] initWithFrame:rect];
    //container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // 2
    CGFloat angleSize = 2*M_PI/self.numberOfSections;
    // 3
    for (int i = 0; i < self.numberOfSections; i++) {
        // 4 - Create image view
        UIImageView *im = [[UIImageView alloc] init];
        im.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                        container.bounds.size.height/2.0-container.frame.origin.y);
        im.transform = CGAffineTransformMakeRotation(angleSize*i + .8);
        im.alpha = minAlphavalue;
        //        im.backgroundColor = [UIColor redColor];
        im.tag = i;
        if (i == 0) {
            im.alpha = maxAlphavalue;
        }
        // 5 - Set sector image
        float offset = rect.size.height/9;
        float iconSize = 2.2 * offset;
        
        RotaryImageView *si = [[RotaryImageView alloc] initWithFrame: CGRectMake(offset, offset, iconSize, iconSize)];
        
        si.image = [UIImage imageNamed:[NSString stringWithFormat:@"danphone"]];
        si.transform = CGAffineTransformMakeRotation(-1 * (angleSize*i + .8));
        [im addSubview:si];
        [imageArray addObject:si];
        si.tag = i;
        [sectorArray addObject:im];
        
        self.userInteractionEnabled = YES;
        
        im.userInteractionEnabled = YES;
        si.userInteractionEnabled = YES;
        
        // 6 - Add image view to container
        [container addSubview:im];
        
    }
    // 7
    container.userInteractionEnabled = NO;
    
    // 8 - Initialize sectors
    sectors = [NSMutableArray arrayWithCapacity:self.numberOfSections];

    if (self.numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }

    // 9 - Call protocol method
    [self addSubview:container];
    RotaryWheelControl *rotaryControl = [[RotaryWheelControl alloc] initWithFrame:self.bounds];
    [self addSubview:rotaryControl];
    [rotaryControl setUpControlWithSelf:self andImageArray:imageArray];

    
    [self startTimer];
    
    UIRectFrame(myFrame);
    CGContextFillRect(context, myFrame);

}

-(void)startTimer
{
    NSLog(@"staring myTimer %@", self.timer.description);
    NSLog(@"staring myTimer");
    [self.timer invalidate]; // kill old timer, if it exists
    //         4 - Timer for rotating wheel
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(rotate)
                                                userInfo:nil
                                                 repeats:YES];
    timerDoesExist = YES;
}

-(BOOL)timerExists
{
    return timerDoesExist;
}

-(void)getPlacement
{
    // 1 - Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // 2 - Initialize new value
    CGFloat newVal = 0.0;
    // 3 - Iterate through all the sectors
    for (RotarySector *s in sectors) {
        // 4 - Check for anomaly (occurs with even number of sectors)
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // 5 - Find the quadrant (positive or negative)
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSector = s.sector;
            }
        }
        // 6 - All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            
            currentSector = s.sector;
        }
        // 8 - Call protocol method
        [self.delegate wheelDidChangeValue:currentSector];
    }
    // 7 - Set up animation for final rotation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    for (RotaryImageView *view in imageArray)
    {
        UIView *parent = view.superview;
        CGFloat r = atan2f(parent.transform.b, parent.transform.a);
        CGFloat cr = atan2f(container.transform.b, container.transform.a);
        
        view.transform = CGAffineTransformMakeRotation(- (r+cr) );
    }
    
    // 10 - Highlight selected sector
    UIImageView *im = [self getSectorByValue:currentSector];
    im.alpha = maxAlphavalue;
    [UIView commitAnimations];
}


- (void) rotate {
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIImageView *im = [self getSectorByValue:currentSector];
        float valueForRotate;
        for (RotarySector *s in sectors)
        {
            if (s.sector == 1)
            {
            valueForRotate = s.midValue;
            CGAffineTransform t = CGAffineTransformRotate(container.transform, -1 * valueForRotate);
            container.transform = t;
            for (RotaryImageView *view in imageArray)
            {
                view.transform = CGAffineTransformRotate(view.transform, valueForRotate);
            }
             im.alpha = minAlphavalue;
             [self getPlacement];
        }
       
            // 4 - Check for anomaly (occurs with even number of sectors)
        }

        
    } completion:nil];
    
    //hardcoded value for the amount of radians necessary to rotate one segment given there are 6 segment
    
}

- (void) stopTimer
{
    NSLog(@"stopping Timer %@", self.timer.description);
    [self.timer invalidate];
    self.timer = nil;
    timerDoesExist = NO;
}


- (void) buildSectorsEven {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/self.numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < self.numberOfSections; i++) {
        RotarySector *sector = [[RotarySector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
            
        }
        mid -= fanWidth;
        NSLog(@"cl is %@", sector);
        // 5 - Add sector to array
        [sectors addObject:sector];
    }
}
- (UIImageView *) getSectorByValue:(int)value {
    UIImageView *res;
    NSArray *views = [container subviews];
    for (UIImageView *im in views) {
        if (im.tag == value)
            res = im;
    }
    return res;
}

- (void) buildSectorsOdd {
    // 1 - Define sector length
    CGFloat fanWidth = M_PI*2/self.numberOfSections;
    // 2 - Set initial midpoint
    CGFloat mid = 0;
    // 3 - Iterate through all sectors
    for (int i = 0; i < self.numberOfSections; i++) {
        RotarySector *sector = [[RotarySector alloc] init];
        // 4 - Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // 5 - Add sector to array
        [sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}


@end
