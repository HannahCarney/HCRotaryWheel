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

@implementation HCRotaryWheel
{
    NSMutableArray *imageArray;
    NSMutableArray *sectorArray;
}

HCRotaryWheel *wheel;

@synthesize numberOfSections = _numberOfSections;
@synthesize sectorView = _sectorView;
@synthesize startTransform;
@synthesize sectors;
@synthesize container;
@synthesize currentSector;
@synthesize timer;
@synthesize timerDoesExist;
@synthesize imageSize;
@synthesize dropShadow;
@synthesize turnOnColorForCurrent;
@synthesize colorForCurrent;


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
    currentSector = 0;
//    _background = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    self.numberOfSections = 6;
    self.minAlphavalue = 1.0;
    self.maxAlphavalue = 1.0;
    self.sectionColor = [UIColor redColor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(stopTimer)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(startTimer)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
}

-(void)drawRect:(CGRect)rect
{
    CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    // Draw for interface builder
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect myFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.width);
    
    //DrawBackground
    CGRect bottomRect = CGRectMake(0, rect.size.height/2.0, rect.size.width, rect.size.height/2.0);
    [self.backgroundColor setFill];
    UIRectFill( bottomRect );

    
    imageArray = [NSMutableArray array];
    sectorArray = [NSMutableArray array];
    // Draw wheel
    self.currentSector = 0;
    [self.delegate wheelDidChangeValue:currentSector];
    [container removeFromSuperview];
    container = nil;
    container = [[UIView alloc] initWithFrame:rect];
    CGFloat angleSize = 2*M_PI/self.numberOfSections;
    for (int i = 0; i < self.numberOfSections; i++) {
        // Create image view
        UIImageView *im = [[UIImageView alloc] init];
        im.layer.anchorPoint = CGPointMake(0, 0);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                        container.bounds.size.height/2.0-container.frame.origin.y);
        
        im.transform = CGAffineTransformMakeRotation(angleSize*i +.8);
        im.alpha = self.minAlphavalue;
        
        [self addSectorShapes:im :rect :angleSize :i];
        
        [imageArray addObject:self.sectorView];
        NSString *rotaryName = [NSString stringWithFormat:@"image%d", i + 1];
        NSString *rotaryColor = [NSString stringWithFormat:@"color%d",i + 1];
        self.sectorView.tag = i;
        id rotaryNameValue = [self valueForKey:rotaryName];
        id rotaryColorValue = [self valueForKey:rotaryColor];
        if (rotaryColorValue != nil) {
            rotaryNameValue = [rotaryNameValue imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        [self.sectorView setValue:rotaryNameValue forKey:@"image"];
        [self.sectorView setValue:rotaryColorValue forKey:@"tintColor"];
        if (i == 0) {
            im.alpha = self.maxAlphavalue;
            if (turnOnColorForCurrent) {
                [self.sectorView setTintColor:colorForCurrent];}
        }
        if (self.dropShadow)
        {
            self.sectorView = [self turnOnIconDropShadow:self.sectorView];
        }
        [sectorArray addObject:im];
        self.userInteractionEnabled = YES;
        
        im.userInteractionEnabled = YES;
        self.sectorView.userInteractionEnabled = YES;
        
        // Add image view to container
        [container addSubview:im];
    }
    container.userInteractionEnabled = NO;
    
    // Initialize sectors
    sectors = [NSMutableArray arrayWithCapacity:self.numberOfSections];
    
    if (self.numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
    // Call protocol method
    [self addSubview:container];
    RotaryWheelControl *rotaryControl = [[RotaryWheelControl alloc] initWithFrame:self.bounds];
    [self addSubview:rotaryControl];
    [rotaryControl setUpControlWithSelf:self andImageArray:imageArray];
    // Start timer
    [self startTimer];
    UIRectFrame(myFrame);
    CGContextFillRect(context, myFrame);
    UIGraphicsEndImageContext();
}

//hypotenuse of equalateral triangle is squareroot of 2 times the length of one leg
-(float)getHypotenuse:(float)side {
    return sqrt(2) * side;
}

//get side of equalateral triangle knowing the hypotenuse
-(float)getSideOfTriangle:(float)hypotenuse{
    return hypotenuse / sqrt(2);
}

//add shapes to wheel
-(void) addSectorShapes:(UIImageView *)im :(CGRect)rect :(float)angleSize :(int)i {
    UIView *v = [[UIView alloc] initWithFrame:rect];
    v.layer.anchorPoint = CGPointMake(0, 0);
    v.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                   container.bounds.size.height/2.0-container.frame.origin.y);
    
    v.transform = CGAffineTransformMakeRotation(((angleSize * i) + angleSize/2));
    
    float radiusOfBigCircle = rect.size.width/2;
    //outer circle
    if (self.outerCircle) {
        [[self layer] addSublayer:[self addOutlineforCircle:radiusOfBigCircle andX:0 andY:(rect.size.height - radiusOfBigCircle * 2)/2]];
    }
    //inner circle
    float iconSize = (radiusOfBigCircle / 2) + self.imageSize;
    float radiusOfLittleCircle = radiusOfBigCircle - [self getHypotenuse:iconSize];
    float hypotenuseOfLittleCircle = [self getHypotenuse:radiusOfLittleCircle];
    float xInner = radiusOfBigCircle - hypotenuseOfLittleCircle;
    if (self.innerCircle) {
        [[self layer] addSublayer:[self addOutlineforCircle:hypotenuseOfLittleCircle andX:xInner andY:(rect.size.height - hypotenuseOfLittleCircle * 2)/2]];
    }
    float iconHeight = [self getSideOfTriangle:radiusOfBigCircle - hypotenuseOfLittleCircle];
    //square icons
    if (self.squareIcons) {
        [im.layer addSublayer:[self addOutlineforSquare:iconHeight  andX:radiusOfLittleCircle]];
    }
    //circle icons
    float hypotenuseOfIcon = [self getHypotenuse:iconHeight];
    if (self.circleIcons) {
        [im.layer addSublayer:[self addOutlineforCircle:hypotenuseOfIcon/2 andX: radiusOfLittleCircle - ((hypotenuseOfIcon - iconHeight)/2) andY: radiusOfLittleCircle - ((hypotenuseOfIcon - iconHeight)/2)]];
    }
    //seperators
    if (self.sectorLines) {
        [v.layer addSublayer:[self addOutlineforSeperator:hypotenuseOfLittleCircle:radiusOfBigCircle: hypotenuseOfIcon]];
    }
    [container addSubview:v];
    self.sectorView = [[RotaryImageView alloc] initWithFrame: CGRectMake(radiusOfLittleCircle, radiusOfLittleCircle, iconHeight, iconHeight)];
    self.sectorView.transform = CGAffineTransformMakeRotation(-1 * (angleSize*i + .8));
    [im addSubview:self.sectorView];
}

-(CAShapeLayer *)addOutlineforCircle:(float)circle andX:(float)xValue andY:(float) yValue{
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(xValue, yValue, circle * 2, circle * 2)] CGPath]];
    [circleLayer setStrokeColor:[self.sectionColor CGColor]];
//    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    return circleLayer;
}

-(CAShapeLayer *)addOutlineforSquare:(float)width andX:(float)starting{
    CAShapeLayer *squareLayer = [CAShapeLayer layer];
    [squareLayer setPath:[[UIBezierPath bezierPathWithRect:CGRectMake(starting, starting, width, width)] CGPath]];
    squareLayer.strokeColor = [self.sectionColor CGColor];
//    squareLayer.fillColor = [[UIColor clearColor] CGColor];
    return squareLayer;
}

-(CAShapeLayer *)addOutlineforSeperator:(float)radiusOfSmallCircle :(float)radiusOfBigCircle :(float)iconSize {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, radiusOfSmallCircle)];
    [path addLineToPoint:CGPointMake(0, radiusOfBigCircle)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = [path CGPath];
    lineLayer.strokeColor = [self.sectionColor CGColor];
//    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    return lineLayer;
}

-(void)startTimer
{
    NSLog(@"staring myTimer %@", self.timer.description);
    NSLog(@"staring myTimer");
    [self.timer invalidate]; // kill old timer, if it exists
    //   Timer for rotating wheel
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
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

-(RotaryImageView *)turnOnIconDropShadow:(RotaryImageView *)imageView
{
    self.sectorView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.sectorView.backgroundColor = [UIColor whiteColor];
    self.sectorView.layer.masksToBounds = true;
    self.sectorView.layer.cornerRadius = imageView.layer.frame.size.width/2;
    self.sectorView.layer.shadowOpacity = 0.3;
    self.sectorView.layer.shadowRadius = 1;
    self.sectorView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    return self.sectorView;
    
}

-(void)getPlacement
{
    //  Get current container rotation in radians
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    // Initialize new value
    CGFloat newVal = 0.0;
    //  Iterate through all the sectors
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
        // All non-anomalous cases
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSector = s.sector;
        }
    }
    //  Set up animation for final rotation
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
    //call protocol method
    [self.delegate wheelDidChangeValue:currentSector];
    // Highlight selected sector
    UIImageView *im = [self getSectorByValue:currentSector];
    
    im.alpha = self.maxAlphavalue;
    if (turnOnColorForCurrent) {
        for (int i = 0; i < [imageArray count]; i++)
        {
            NSString *rotaryColor = [NSString stringWithFormat:@"sectorViewColor%d",i + 1];
            id rotaryColorValue = [self valueForKey:rotaryColor];
            RotaryImageView *imageView = [imageArray objectAtIndex:i];
            [imageView setValue:rotaryColorValue forKey:@"tintColor"];
        }
        for (RotaryImageView *i in im.subviews)
        {
            [i setTintColor:colorForCurrent];
        }
    }
    [UIView commitAnimations];
}

- (void)prepareForInterfaceBuilder {
    
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
                im.alpha = self.minAlphavalue;
                [self getPlacement];
            }
        }
    } completion:nil];
}

- (void) stopTimer
{
    NSLog(@"stopping Timer %@", self.timer.description);
    [self.timer invalidate];
    self.timer = nil;
    timerDoesExist = NO;
}

- (void) buildSectorsEven {
    
    //  Define sector length
    CGFloat fanWidth = M_PI*2/self.numberOfSections;
    // Set initial midpoint
    CGFloat mid = 0;
    //  Iterate through all sectors
    for (int i = 0; i < self.numberOfSections; i++) {
        RotarySector *sector = [[RotarySector alloc] init];
        // Set sector values
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
        // Add sector to array
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
    // Define sector length
    CGFloat fanWidth = M_PI*2/self.numberOfSections;
    // Set initial midpoint
    CGFloat mid = 0;
    // Iterate through all sectors
    for (int i = 0; i < self.numberOfSections; i++) {
        RotarySector *sector = [[RotarySector alloc] init];
        // Set sector values
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.sector = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        // Add sector to array
        [sectors addObject:sector];
        NSLog(@"cl is %@", sector);
    }
}

@end

