//
//  Constant.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"
#import "Matrix2D.h"

#define toVector(cg) [Vector2D vectorWith:(cg).x y:-(cg).y]
#define toCG(v) CGPointMake(v.x, -v.y)
#define GRAVITY [Vector2D vectorWith:0 y:-400]
#define K 0.01
#define E 0.09623
#define ETA 0.95
#define MU 0.4
#define E_COEFF 0.3
#define ZERO 0
#define ZERO_VECTOR [Vector2D vectorWith:0 y:0]
#define ITERATION 10
#define TOLERATNCE 0.001
#define DEGREE_TAG 12
#define DEGREE_OFFX 50
#define DEGREE_OFFY 200
#define DEGREE_OFFWIDTH 40
#define DEGREE_OFFHEIGHT 2
#define POWER_INIT 1
#define ROTATION_INIT 0
#define DIRECTION_PNG @"direction-arorw-selected.png"
#define ARROW_TAG 13
#define ARROW_OFFX 80
#define ARROW_OFFY 260
#define ANCHOR_X 0.5
#define ANCHOR_Y 0.5
#define ANGEL_OFF 0.02
#define HEART_NO 3

#define BOTTOM_X 0
#define BOTTOM_Y 455
#define BOTTOM_WIDTH 2000
#define BOTTOM_HEIGHT 100

#define LEFT_X 0
#define LEFT_Y -500
#define LEFT_WIDTH 2
#define LEFT_HEIGHT 1100

#define RIGHT_X 1400
#define RIGHT_Y -500
#define RIGHT_WIDTH 2
#define RIGHT_HEIGHT 1100

#define GENERAL_MASS 200
#define STRAW_MASS 100
#define WOOD_MASS 150
#define IRON_MASS 200
#define STONE_MASS 250
#define WIND_MASS 201

#define WIND_WIDTH 90
#define WIND_HEIGHT 90
#define RED_X 600
#define BLUE_X 700
#define GREEN_X 800
#define WIND_Y 40

#define RED_FLAG 101
#define GREEN_FLAG 103
#define BLUE_FLAG 102

#define WRED_FLAG 1
#define WBLUE_FLAG 2
#define WGREEN_FLAG 3

#define WOLF_ANI_OFFX 130
#define WOLF_ANI_OFFY 80
#define WOLF_ANI_W 120
#define WOLF_ANI_H 120

#define WOLF_SUCK_OFFX 100
#define WOLF_SUCK_OFFY 80
#define WOLF_SUCK_W 100
#define WOLF_SUCK_H 100

#define WOLF_WIND_DELAY 0.7
#define WOLF_DIE_DELAY 4
#define WOLF_LAST_LIFE 1
#define WOLF_PLAIN_WIND 0

#define GAMEOVER_DELAY 4

#define INIT_VELOCITY 850

#define BAR_W 30
#define BAR_H 350
#define BAR_X 50
#define BAR_Y 50
#define BAR_TAG 11

#define PLAIN_WIND_TAG 100
#define ANI_TAG 1

#define ANI_TIME 0.7

#define WIND @"windblow.png"
#define REDWIND @"windblow1.png"
#define BLUEWIND @"windblow2.png"
#define GREENWIND @"windblow3.png"
#define STOP @"Stop"

#define WOLF_X 80
#define WOLF_Y 300

typedef enum{firstEdge,secondEdge,thirdEdge,fourthEdge} EdgeNo;
typedef enum{bound, actor,circle,EMPTY,KEY} RectType;
typedef enum{RED,BLUE,BLACK,GREEN,YELLOW,GRAY,TRANSPARENT} COLORTYPE;

#define TIME_INTERVAL 0.01
