//
//  ViewController.h
//  Game
//
//  Created by sai on 1/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "GamePig.h"
#import "GameWolf.h"
#import "GameBlock.h"
#import "GamePorjectile.h"
#import "World.h"
#import "Constant.h"
#import <QuartzCore/CALayer.h> 
//#import "cocos2d.h"
//#import "Box2D.h"

#define BACKGROUND_PNG @"background.png"
#define GROUND_PNG @"ground.png"
#define RESET @"Reset"
#define LOAD @"Load"
#define SAVE @"Save"
#define SYSTEM_INFO @"System Information"
#define QL_SUCCESS @"Quick-Load successfully"
#define QS_SUCCESS @"Quick-Save successfully"
#define OK @"OK"
#define DELETE @"Delete"
#define PLAY @"Play"


typedef enum{
    wolfPlayer=1,
    pigPlayer=2,
    blockPlayer=3
}character;

typedef enum{
    strawImg = 4,
    woodImg = 5,
    ironImg = 6,
    stoneImg = 7
}textture;

@interface ViewController : UIViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,myDelegate>



- (IBAction)buttonPressed:(id)sender;
- (void)setGestures:(id)obj;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *playButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) IBOutlet UIScrollView *gamearea;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *loadButton;

@property (strong, nonatomic) IBOutlet UIView *topBar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *levelOneButtom;
@property UIImageView* finalAnimation;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *levelTwoButtom;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *levelThreeButton;
@property  GameObject* pig;

@property  GameObject* wolf;

@property  GameObject* block;

@property  GameObject* rootOfBlocks;

@property GameObject* wind;

@property GamePorjectile* difProjectile;

@property World* myWorld;

@property UIImageView* animationWolf;

@property UIImageView* animationWind;

@property Boolean isSavedInThisGame;

@property double powerIndex;

@property UIActionSheet* saveSheet;

@property UIActionSheet* loadSheet;

@property UIActionSheet* deleteSheet;

@property Boolean isStarting;

@property CGFloat arrowRotation;

- (void)gameOver;

@end
