//
//  world.h
//  ps4retry
//
//  Created by sai on 2/12/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
/*
 this class is the main physical engine part, which can simulate all possible collision in the world
 */
#import <Foundation/Foundation.h>
#import "Constant.h"
#import "Rectangle.h"
#import "CollisionDetector.h"
#import "ContactPoint.h"

@interface World : NSObject<UIAccelerometerDelegate>

@property Vector2D* gravity;
@property 
NSMutableArray* objectsList;
@property NSTimer* timer;
@property CollisionDetector* detector;
@property UIAccelerometer* accelerometer;
@property Vector2D* coeff;

-(void)run;
//start simulating

- (void)updatePosition;
//update the rectangle's position in this world

@end
