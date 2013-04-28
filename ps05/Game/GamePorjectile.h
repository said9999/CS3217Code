//
//  GamePorjectile.h
//  Game
//
//  Created by sai on 2/20/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

@interface GamePorjectile : GameObject

@property UIView* greenWind;
@property UIView* plainWind;
@property UIImageView* greenWindAnimation;
@property UIImageView* redWindAnimation;
@property UIImageView* blueWindAnimation;
@property UIImageView* firstAnimation;
@property UIView* blueWind;
@property UIView* redWind;
- initWithX:(CGFloat)x Y:(CGFloat)y;

@end
