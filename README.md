# RotaryWheel
A Rotary Wheel for altering content that can be customised in Interface Builder

[![Demo CountPages alpha](https://j.gifs.com/v1eBnx.gif)](https://www.youtube.com/watch?v=pKzez4-whqY&feature=youtu.be)

## Functionality

- Rotates on a Timer until Wheel is touched
- Timer shuts off and then can be dragged or touched to spin the wheel
- Functionality for changing any content when wheel turns
- Background, number of elements and images can be changed in the Interface Builder


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
