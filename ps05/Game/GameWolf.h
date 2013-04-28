//
//  GameWolf.h
//  Game
//
//  Created by sai on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

#define WOLF_ORIGINHEIGHT 90
#define WOLF_ORIGINWIDTH 150
#define WOLF_REALHEIGHT 150
#define WOLF_REALWIDTH 225
#define WOLF_ORIGINX 100
#define WOLF_ORIGINY 80
#define WOLF_PNG @"wolfs.png"

@interface GameWolf : GameObject

@property UIImageView* dieAnimation;
@property UIImageView* suckAnimation;
@property UIView* heartOne;
@property UIView* heartTwo;
@property UIView* heartThree;
@property int heartCount;


@end
