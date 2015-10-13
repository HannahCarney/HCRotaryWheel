# HCRotaryWheel

[![CI Status](http://img.shields.io/travis/Hannah Carney/HCRotaryWheel.svg?style=flat)](https://travis-ci.org/Hannah Carney/HCRotaryWheel)
[![Version](https://img.shields.io/cocoapods/v/HCRotaryWheel.svg?style=flat)](http://cocoapods.org/pods/HCRotaryWheel)
[![License](https://img.shields.io/cocoapods/l/HCRotaryWheel.svg?style=flat)](http://cocoapods.org/pods/HCRotaryWheel)
[![Platform](https://img.shields.io/cocoapods/p/HCRotaryWheel.svg?style=flat)](http://cocoapods.org/pods/HCRotaryWheel)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

# HCRotaryWheel
A Rotary Wheel for altering content that can be customised in Interface Builder

[![Demo CountPages alpha](https://j.gifs.com/v1eBnx.gif)](https://www.youtube.com/watch?v=pKzez4-whqY&feature=youtu.be)


## Functionality

- Rotates on a Timer until Wheel is touched
- Timer shuts off and then can be dragged or touched to spin the wheel
- Functionality for changing any content when wheel turns
- Background, number of elements and images can be changed in the Interface Builder

## How to use
1. Clone Project
2. Build in Xcode for example project
3. Drag Controls folder into your project
4. Enter class in Identity Inspector

<a href="http://www.freeimagehosting.net/commercial-photography/illinois/chicago/"><img src="http://i.imgur.com/GPt5Kfs.png" alt="Chicago commercial photographers"></a>

Edit in Attributes Inspector

<a href="http://www.freeimagehosting.net/commercial-photography/illinois/chicago/"><img src="http://i.imgur.com/z0CzEyI.png" alt="Chicago commercial photographers"></a>

## Code

In your ViewController.h drag your HCRotaryWheelView as an IBOutlet and add RotaryProtocol to call Delegate Methods

@interface ViewController : UIViewController <RotaryProtocol>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet HCRotaryWheelView *rotaryWheelView;

@end

In ViewController.m 

- (void)viewDidLoad {
[super viewDidLoad];
//set view controller as delegate to Rotary Wheel
self.rotaryWheelView.delegate = self;
//set initial Text for a label or other content
self.textLabel.text = @"Bear";
}

// built in HCRotaryWheel Delegate Method
- (void) wheelDidChangeValue:(int)currentSector {
// change any text when wheel rotates, is tapped or dragged
self.textLabel.text = [self getDescriptionText:currentSector];
}

- (NSString *) getDescriptionText:(int)newValue {
NSString *text = @"";
switch(newValue) {
case 0:
text = @"Bear";
break;
case 1:
text = @"Monkey";
break;
case 2:
text = @"Dog";
break;
case 3:
text = @"Ghost";
break;
case 4:
text = @"Peace";
break;
case 5:
text = @"Alien";
break;
default:
break;
}
return text;
}

## Installation

HCRotaryWheel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HCRotaryWheel"
```

## Author

Hannah Carney, hannahcarneyart@gmail.com

## License

HCRotaryWheel is available under the MIT license. See the LICENSE file for more info.
