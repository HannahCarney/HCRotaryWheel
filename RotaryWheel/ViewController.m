//
//  ViewController.m
//  RotaryWheel
//
//  Created by Hannah Carney on 01/10/2015.
//  Copyright © 2015 Hannah Carney. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rotaryWheelView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) wheelDidChangeValue:(int)currentSector {
    self.textLabel.text = [self getDescriptionText:currentSector];
}

- (NSString *) getDescriptionText:(int)newValue {
    NSString *text = @"";
    switch(newValue) {
        case 0:
            text = @"The first image";
            break;
        case 1:
            text = @"Don't forget to refresh your views in IB builder";
            break;
        case 2:
            text = @"Don't forget to star me on github: hannahcarneyart";
            break;
        case 3:
            text = @"Woo circles!";
            break;
        case 4:
            text = @"Isn't programming fun?";
            break;
        case 5:
            text = @"Feel free to make a pull request to the repo";
            break;
        default:
            text = @"Default text!";
            break;
    }
    return text;
}

@end
