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
#define GRAVITY [Vector2D vectorWith:0 y:-600]
#define K 0.01
#define E 0.05
#define ETA 0.95
#define MU 0.4
#define E_COEFF 0.55
#define ZERO 0
#define ZERO_VECTOR [Vector2D vectorWith:0 y:0]
#define ITERATION 10
#define TOLERATNCE 0.001
typedef enum{firstEdge,secondEdge,thirdEdge,fourthEdge} EdgeNo;
typedef enum{bound, actor} RectType;
typedef enum{RED,BLUE,BLACK,GREEN,YELLOW,GRAY} COLORTYPE;

#define TIME_INTERVAL 0.015
