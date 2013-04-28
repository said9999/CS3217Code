//
//  GameBlock.h
//  Game
//
//  Created by sai on 2/1/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

#define BLOCK_ORIGINHEIGHT 55
#define BLOCK_ORIGINWIDTH 55
#define BLOCK_REALHEIGHT 130
#define BLOCK_REALWIDTH 30
#define BLOCK_ORIGINX 320
#define BLOCK_ORIGINY 80
#define STRAW_PNG @"straw.png"
#define WOOD_PNG @"wood.png"
#define IRON_PNG @"iron.png"
#define WOLFS_PNG @"wolfs.png"
#define STONE_PNG @"stone.png"


@interface GameBlock : GameObject

+ (void)changeTexture:(UIView*)inputView;

@end
